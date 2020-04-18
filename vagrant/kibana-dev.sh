#!/usr/bin/env bash
elastic_version=$1
elastic_host=$2

# Install Node.js
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - > /dev/null
yum install nodejs -y 

# Clone Kibana tag
git clone https://github.com/elastic/kibana -b "v$elastic_version" --single-branch --depth=1 

# Install n, yarn and Node.js version desired by Kibana
npm install -g n
npm install -g yarn@1.10.1
n "$(cat /home/vagrant/kibana/.nvmrc)"
yes | mv /usr/local/bin/node /usr/bin/
yes | mv /usr/local/bin/npm /usr/bin/


# Build Kibana modules
cd /home/vagrant/kibana && yarn kbn bootstrap

# Correct owner for Kibana directories
chown -R vagrant:vagrant /home/vagrant/kibana

# Increasing the amount of inotify watchers
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo "Usage:"
echo "  yarn start --oss --no-base-path --server.host=\"0.0.0.0\" --elasticsearch.hosts=\"http://$elastic_host:9200\""
echo "Note: place your pluging under /home/vagrant/kibana/plugins/<your_plugin>/"