# c2matrix-analyzer

Basic c2-matrix analysis enviroment using Suricata + Wazuh + Elastic stack 


- The agent VM has Suricata configured to use the Emerging Threats Open Rules.
- Suricata alerts are collected by Wazuh's agent and sent to Wazuh's manager. 
- Wazuh Manager sends alerts to Elasticsearch and can be viewed in Kibana in both the Discover section and the Wazuh plugin.

![Analysis00](https://github.com/eortizbrossard/c2matrix-evaluation/blob/master/images/suricata00.png)

![Analysis01](https://github.com/eortizbrossard/c2matrix-evaluation/blob/master/images/suricata01.png)

![Analysis02](https://github.com/eortizbrossard/c2matrix-evaluation/blob/master/images/suricata02.png)

Requirements:
- Virtualbox
- Vagrant

Enviroment:
1. master: Manager Wazuh all in one + Elasticsearch + Kibana
OS: Centos7
Kibana port 5601 is attached to the local host: 5601

2. agent:  Agent Wazuh + Suricata + ET Open
OS: Centos7

3. c2server:
OS: Kali / Debian / Centos7  # Choose one by changing in Vagrantfile

# Instructions:
For deployment, do the following:

Extract all files in a directory, and launches the commands from this directory

To deploy the entire environment:
```
$ vagrant up
``` 
Deploy a vm:
```
$ vagrant up [VM_NAME]
```
Destroy the whole enviroment:
```
$ vagrant destroy  
```
Destroy a vm:
```
$ vagrant destroy [VM_NAME]
```
Access Kibana:
```
http://localhost:5601 
```
Aacces to a vm:
```
$ vagrant ssh [VM_NAME]
```
Network: 
- master_ip = "192.168.76.2"
- agent_ip = "192.168.76.20"
- c2server_ip = "192.168.76.30"

# References:
```
- Red Team Kali Package. Inside it has instructions for installing various C2 programs (It may apply to Debian).
https://bugs.kali.org/view.php?id=6093

- C2 Matrix:
https://howto.thec2matrix.com/
https://docs.google.com/spreadsheets/d/1b4mUxa6cDQuTV2BPC6aA-GR4zGZi0ooPYtBe4IgPsSc/edit#gid=0

- Suricata
https://suricata-ids.org/

- Emergint Threat s
https://rules.emergingthreats.net/

- Wazuh
https://github.com/wazuh/wazuh

- Elastic
https://github.com/elastic
```
