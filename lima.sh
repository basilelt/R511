#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    limactl stop R511
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    limactl start R511 && limactl shell R511
fi
