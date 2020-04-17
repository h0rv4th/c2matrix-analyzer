# c2matrix-evaluation

Basic c2 environment for testing using Suricata + Wazuh + Elastic stack
Inside is the Vagrantfile + several scripts to deploy the enviroment. 

It has two virtual machines at the moment:
1. master: Manager Wazuh all in one + Elasticsearch + Kibana
OS: Centos7
Kibana port 5601 is attached to the local host: 5601

2. agent:  Agent Wazuh + Meerkat + ET Open 
OS: Centos7

3. c2server: 
OS: Kali / Debian / Centos7  # Choose one by changing in Vagrantfile

Instructions:
For deployment, do the following:

Decompresses all files in a directory, and launches the commands from this directory

To deploy the entire environment:
$ vagrant up 

To deploy a vm:
$ vagrant up [VM_NAME]


To destroy a vm:
$ vagrant destroy [VM_NAME]

To access Kibana:
http://localhost:5601 

To acces to a vm:
$ vagrant ssh [VM_NAME]

Network: 
master_ip = "192.168.76.2"
agent_ip = "192.168.76.20"
c2server_ip = "192.168.76.30"

References:

Red Team Kali Package. Inside it has instructions for installing various C2 programs (It may apply to Debian).
https://bugs.kali.org/view.php?id=6093

- C2 Matrix:
https://howto.thec2matrix.com/
https://docs.google.com/spreadsheets/d/1b4mUxa6cDQuTV2BPC6aA-GR4zGZi0ooPYtBe4IgPsSc/edit#gid=0





