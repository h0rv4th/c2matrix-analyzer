#!/usr/bin/env bash
elastic_version=$1
elastic_host=$2
wazuh_version=$3
app=$wazuh_version"_"$elastic_version

# Install Kibana
yum install kibana-"$elastic_version" -y -q

# Enable Kibana service
systemctl daemon-reload
systemctl enable kibana

# Kibana configuration
sed -i 's:\#server.host\: "localhost":server\.host\: "0.0.0.0":g' /etc/kibana/kibana.yml

# Elasticsearch hosts
sed -i 's:#elasticsearch.hosts:elasticsearch.hosts:g' /etc/kibana/kibana.yml
sed -i "s#http://localhost:9200#http://$elastic_host:9200#g" /etc/kibana/kibana.yml

chown -R kibana:kibana /usr/share/kibana/optimize
chown -R kibana:kibana /usr/share/kibana/plugins

# Install the Wazuh app
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-$app.zip

# Set .wazuh, .wazuh-version and wazuh-monitoring index shards and index replicas
sed -i 's/#wazuh.replicas.*: 1/wazuh.replicas: 0/g' /usr/share/kibana/plugins/wazuh/config.yml
sed -i 's/#wazuh-version.replicas.*: 1/wazuh-version.replicas: 0/g' /usr/share/kibana/plugins/wazuh/config.yml
sed -i 's/#wazuh.monitoring.shards.*: 5/wazuh.monitoring.shards: 1/g' /usr/share/kibana/plugins/wazuh/config.yml
sed -i 's/#wazuh.monitoring.replicas.*: 1/wazuh.monitoring.replicas: 0/g' /usr/share/kibana/plugins/wazuh/config.yml

chown -R kibana:kibana /usr/share/kibana/optimize
chown -R kibana:kibana /usr/share/kibana/plugins

# Run Kibana
systemctl restart kibana
