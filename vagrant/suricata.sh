#!/usr/bin/env bash
wazuh_version=$1
manager_ip=$2
node_type=$3

# Install Suricata
if [[ $node_type == "master" ]]

then
#Add suricata to agent.conf
echo '''<agent_config>
    <localfile>
        <log_format>json</log_format>
        <location>/var/log/suricata/eve.json</location>
    </localfile>
</agent_config>
''' >> /var/ossec/etc/shared/default/agent.conf
else
cd /root
wait
yum -y install epel-release wget jq
wait
curl -O https://copr.fedorainfracloud.org/coprs/jasonish/suricata-stable/repo/epel-7/jasonish-suricata-stable-epel-7.repo
wait
yum -y install suricata
wait
wget https://rules.emergingthreats.net/open/suricata-4.0/emerging.rules.tar.gz
wait
tar zxvf emerging.rules.tar.gz
wait
rm /etc/suricata/rules/* -f
wait
mv rules/*.rules /etc/suricata/rules/
wait
rm -f /etc/suricata/suricata.yaml
wait
wget -O /etc/suricata/suricata.yaml http://www.branchnetconsulting.com/wazuh/suricata.yaml
wait
# Run Wazuh manager and Wazuh API
systemctl daemon-reload
systemctl enable suricata
systemctl start suricata
# Run Wazuh manager and Wazuh API
systemctl restart wazuh-agent
fi
