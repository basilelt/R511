#!/usr/bin/env bash
set -euxo pipefail

cd /home/vagrant

apt-get update
apt-get install -y python3 python3-pip python3-venv

python3 -m venv .venv
source .venv/bin/activate
pip install ansible --no-input --no-cache-dir

ansible-playbook -i 'localhost,' play-TP-Test-NP.yml
