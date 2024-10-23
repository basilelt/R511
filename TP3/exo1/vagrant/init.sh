#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get install -y vim nginx git

DEBIAN_FRONTEND=noninteractive apt-get install -y console-data

echo "console-data console-data/keymap/policy select Select keymap from full list" | debconf-set-selections
echo "console-data console-data/keymap/full select fr" | debconf-set-selections
