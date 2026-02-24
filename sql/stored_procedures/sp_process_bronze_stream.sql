CREATE OR REPLACE PROCEDURE BRONZE_DB.CONTROL.SP_PROCESS_BRONZE_STREAM(
    STREAM_NAME VARCHAR,
    TARGET_TABLE VARCHAR,
    PRIMARY_KEY_COLUMNS VARCHAR
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    merge_statement VARCHAR;
    pk_join_clause VARCHAR;
    pk_col VARCHAR;
    pk_cursor CURSOR FOR SELECT TRIM(VALUE) AS COL FROM TABLE(SPLIT_TO_TABLE(:PRIMARY_KEY_COLUMNS, ','));
    rows_affected NUMBER;
BEGIN
    -- 1. Construct Dynamic Join Clause for Composite Keys
    pk_join_clause := '';
    OPEN pk_cursor;
    FOR record IN pk_cursor DO
        pk_col := record.COL;
        IF (pk_join_clause != '') THEN
            pk_join_clause := pk_join_clause || ' AND ';
        END IF;
        pk_join_clause := pk_join_clause || 'target.' || pk_col || ' = source.' || pk_col;
    END FOR;
    CLOSE pk_cursor;

    -- 2. Construct MERGE Statement
    -- This logic handles standard CDC: Insert new, Update existing, Soft Delete if deleted in source
    merge_statement := '
    MERGE INTO ' || TARGET_TABLE || ' AS target
    USING (
        SELECT * 
        FROM ' || STREAM_NAME || '
        QUALIFY ROW_NUMBER() OVER (PARTITION BY ' || PRIMARY_KEY_COLUMNS || ' ORDER BY _FIVETRAN_SYNCED DESC) = 1
    ) AS source
    ON ' || pk_join_clause || '
    WHEN MATCHED AND source.METADATA$ACTION = ''DELETE'' THEN
        UPDATE SET target._IS_DELETED = TRUE, target._FIVETRAN_SYNCED = source._FIVETRAN_SYNCED
    WHEN MATCHED AND source.METADATA$ACTION = ''INSERT'' THEN
        UPDATE SET target.* = source.*, target._IS_DELETED = source._FIVETRAN_DELETED
    WHEN NOT MATCHED AND source.METADATA$ACTION = ''INSERT'' THEN
        INSERT VALUES (source.*)
    ';

    -- 3. Execute Merge
    EXECUTE IMMEDIATE :merge_statement;
    
    -- 4. Log Execution
    INSERT INTO BRONZE_DB.CONTROL.TASK_EXECUTION_LOG (TASK_NAME, EXECUTION_STATUS, START_TIME, END_TIME)
    VALUES (:STREAM_NAME, 'SUCCESS', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

    RETURN 'Stream processed successfully: ' || STREAM_NAME;

EXCEPTION
    WHEN OTHER THEN
        INSERT INTO BRONZE_DB.CONTROL.TASK_EXECUTION_LOG (TASK_NAME, EXECUTION_STATUS, ERROR_MESSAGE, START_TIME, END_TIME)
        VALUES (:STREAM_NAME, 'FAILED', SQLERRM, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());
        RETURN 'Error processing stream: ' || SQLERRM;
END;
$$;