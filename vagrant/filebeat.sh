#!/usr/bin/env bash
elastic_version=$1
elastic_host=$2
wazuh_version=$3

# Install Filebeat
yum install filebeat-$elastic_version -y -q

# Enable services
systemctl daemon-reload
systemctl enable filebeat

# Filebeat configuration
curl -so /etc/filebeat/filebeat.yml "https://raw.githubusercontent.com/wazuh/wazuh/v$wazuh_version/extensions/filebeat/7.x/filebeat.yml"
curl -so /etc/filebeat/wazuh-template.json "https://raw.githubusercontent.com/wazuh/wazuh/v$wazuh_version/extensions/elasticsearch/7.x/wazuh-template.json"
curl -s https://packages.wazuh.com/3.x/filebeat/wazuh-filebeat-0.1.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module

# File permissions
chmod go-w /etc/filebeat/filebeat.yml
chmod go-w /etc/filebeat/wazuh-template.json

sed -i "s:YOUR_ELASTIC_SERVER_IP:$elastic_host:g" /etc/filebeat/filebeat.yml
## Configuring ILM (WS-245):
sed '''s/  "settings": {\n    "index.refresh_interval": "5s",/  "settings": {\n    "index.lifecycle.name": "DeleteAfterOneYearRentention",\n    "index.lifecycle.rollover_alias": "wazuh",\n    "index.refresh_interval": "5s",/g''' /etc/filebeat/wazuh-template.json -i

sed -i "s/setup.ilm.enabled: false/setup.ilm.enabled: true/g" /etc/filebeat/filebeat.yml 
echo '''setup.ilm.policy_name: 'DeleteAfterOneYearRentention'
setup.ilm.policy_file: '/etc/filebeat/policy.json'
output.elasticsearch.ilm.enabled: true
output.elasticsearch.ilm.rollover_alias: "wazuh"
output.elasticsearch.ilm.pattern: "{now/d}-000001"
''' >> /etc/filebeat/filebeat.yml

echo '''{"policy": {"phases": {"hot": {"actions": {"rollover": {"max_age": "30d","max_size": "50gb"},"set_priority": {"priority": 100}}},"warm": {"actions": {"set_priority": {"priority": 50}}},"cold": {"min_age": "120d","actions": {"set_priority": {"priority": 0}}},"delete": {"min_age": "365d","actions": {"delete": {}}}}}}'''>> /etc/filebeat/policy.json
chown root:root /etc/filebeat/filebeat.yml 

filebeat setup --index-management -E setup.template.json.enabled=false

# Run Filebeat
systemctl restart filebeat
