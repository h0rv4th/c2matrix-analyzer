#!/usr/bin/env bash
wazuh_version=$1
installation_type=$2
branch=$3

# Install Node.js
curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - > /dev/null
yum install nodejs -y
npm config set user 0

if [[ $installation_type == "sources" ]]
then
  curl -Ls https://github.com/wazuh/wazuh-api/archive/$branch.tar.gz | tar zx
  cd wazuh-api* || echo "wazuh-api* directory not found" && exit
  echo 'REINSTALL=y' > configuration/preloaded_vars.conf
  bash ./install_api.sh
else
  # Install Wazuh API
  yum install wazuh-api-"$wazuh_version" -y -q
fi

# Enable service
systemctl daemon-reload
systemctl enable wazuh-api

# Run Wazuh API
systemctl restart wazuh-api
