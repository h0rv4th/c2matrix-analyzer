#!/usr/bin/env bash
wazuh_version=$1
manager_ip=$2
node_type=$3

# Install Wazuh manager
yum install wazuh-manager-"$wazuh_version" -y -q

if [[ $node_type == "master" ]]
then
    # Configure Wazuh master node
    sed -i 's:<key></key>:<key>9d273b53510fef702b54a92e9cffc82e</key>:g' /var/ossec/etc/ossec.conf
    sed -i "s:<node>NODE_IP</node>:<node>$manager_ip</node>:g" /var/ossec/etc/ossec.conf
    sed -i -e '/<cluster>/,/<\/cluster>/ s|<disabled>[a-z]\+</disabled>|<disabled>no</disabled>|g' /var/ossec/etc/ossec.conf
    
else
    # Configure Wazuh worker node
    sed -i 's:<node_name>node01</node_name>:<node_name>node02</node_name>:g' /var/ossec/etc/ossec.conf
    sed -i 's:<key></key>:<key>9d273b53510fef702b54a92e9cffc82e</key>:g' /var/ossec/etc/ossec.conf
    sed -i "s:<node>NODE_IP</node>:<node>$manager_ip</node>:g" /var/ossec/etc/ossec.conf
    sed -i 's:<node_type>master</node_type>:<node_type>worker</node_type>:g' /var/ossec/etc/ossec.conf
    sed -i -e '/<cluster>/,/<\/cluster>/ s|<disabled>[a-z]\+</disabled>|<disabled>no</disabled>|g' /var/ossec/etc/ossec.conf
fi

# Enable Wazuh services
systemctl daemon-reload
systemctl enable wazuh-manager

# Run Wazuh manager and Wazuh API
systemctl restart wazuh-manager
