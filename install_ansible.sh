#!/bin/bash
sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
software-properties-common &&
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible