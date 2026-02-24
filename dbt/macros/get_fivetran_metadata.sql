{% macro get_fivetran_metadata() %}
    , _FIVETRAN_SYNCED AS SYNCED_AT
    , _FIVETRAN_DELETED AS IS_DELETED
{% endmacro %}