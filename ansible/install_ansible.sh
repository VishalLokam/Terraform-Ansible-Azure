#!/bin/bash
sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common &&
sudo add-apt-repository --yes --update ppa:ansible/ansible &&
sudo apt install -y ansible
cd /home/azureadmin/ansible &&
chmod 400 private_ssh_key_azure.pem &&
ansible-playbook -i inventory.ini --private-key=private_ssh_key_azure.pem install_nginx.yaml
# ansible-playbook -i inventory.ini --private-key=private_ssh_key_azure.pem install_nginx.yaml
