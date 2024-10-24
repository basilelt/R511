#!/usr/bin/env bash
set -euxo pipefail

cd /home/vagrant

# Install python3, pip3 and python3-venv
# Can't use python3-venv because of a bug in Ubuntu
sudo apt-get update
sudo apt-get install -y python3 python3-pip #python3-venv

#python3 -m venv .venv
#source .venv/bin/activate
pip3 install ansible --no-input --no-cache-dir

# Add ansible to path
export PATH=$PATH:/home/vagrant/.local/bin

ansible-playbook -i 'localhost,' localhost play-TP-Test-NP.yml
