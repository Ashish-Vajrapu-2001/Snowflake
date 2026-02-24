import requests
import yaml
import os

# Configuration
API_KEY = "{{PLACEHOLDER_FIVETRAN_API_KEY}}"
API_SECRET = "{{PLACEHOLDER_FIVETRAN_API_SECRET}}"
BASE_URL = "https://api.fivetran.com/v1"
GROUP_ID = "your_destination_group_id"

AUTH = (API_KEY, API_SECRET)
HEADERS = {"Content-Type": "application/json"}

def create_connector(config_file):
    with open(config_file, 'r') as f:
        data = yaml.safe_load(f)
    
    connector_data = data['connector']
    
    payload = {
        "service": connector_data['service'],
        "group_id": GROUP_ID,
        "config": connector_data['config'],
        "trust_certificates": True,
        "run_setup_tests": True
    }
    
    print(f"Creating connector: {connector_data['name']}...")
    
    response = requests.post(
        f"{BASE_URL}/connectors",
        auth=AUTH,
        headers=HEADERS,
        json=payload
    )
    
    if response.status_code == 201:
        print(f"Success! Connector ID: {response.json()['data']['id']}")
    else:
        print(f"Failed: {response.text}")

if __name__ == "__main__":
    connectors = [
        "fivetran/connectors/erp_connector.yaml",
        "fivetran/connectors/crm_connector.yaml",
        "fivetran/connectors/marketing_connector.yaml"
    ]
    
    for c in connectors:
        create_connector(c)