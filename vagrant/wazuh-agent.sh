#!/usr/bin/env bash
wazuh_version=$1
manager_ip=$2

# Install Wazuh agent
yum install wazuh-agent-"$wazuh_version" -y -q

# Register agent using authd
/var/ossec/bin/agent-auth -m "$manager_ip"
sed -i "s:MANAGER_IP:$manager_ip:g" /var/ossec/etc/ossec.conf

# Enable and restart the Wazuh agent
systemctl daemon-reload
systemctl enable wazuh-agent
systemctl restart wazuh-agent
