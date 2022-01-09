#!/bin/bash
apt-get -y install sshpass
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/install-elastic.yml