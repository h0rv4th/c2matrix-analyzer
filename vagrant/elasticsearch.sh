#!/usr/bin/env bash
elastic_version=$1
elastic_host=$2
wazuh_version=$3

# Install Elasticsearch
yum install elasticsearch-$elastic_version -y -q

# Enable Elasticsearch services
systemctl daemon-reload
systemctl enable elasticsearch

# Configure Elasticsearch master node
cat > /etc/elasticsearch/elasticsearch.yml << EOF
cluster.name: "my-cluster"
node.name: "es-node-1"
node.master: true
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
cluster.initial_master_nodes: 
  - "es-node-1"
EOF

echo "network.host: $elastic_host" >> /etc/elasticsearch/elasticsearch.yml

# Correct owner for Elasticsearch directories
chown elasticsearch:elasticsearch -R /etc/elasticsearch
chown elasticsearch:elasticsearch -R /usr/share/elasticsearch
chown elasticsearch:elasticsearch -R /var/lib/elasticsearch

# Run Elasticsearch
systemctl restart elasticsearch