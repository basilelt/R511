#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
    cd $current_dir
    rm -rf tmp
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "Current directory (full path): $current_dir"
    cd "$current_dir"

    mkdir -p tmp
    cd tmp

    cat > Dockerfile <<EOF
#Dockerfile
FROM debian:12-slim

RUN apt update && \
    apt install -y sudo openssh-server python3 python3-pip && \
    apt clean && \
    apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash toto && \
    echo "toto:toto" | chpasswd && \
    adduser toto sudo && \
    echo "toto ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
EOF

    docker build -t debian-ansible-image .

    if [[ "$(uname)" == "Darwin" ]]; then
        docker_host_ip=$(docker run --rm alpine ip route | awk 'NR==1 {print $3}')
        docker run -d --name ansible-container \
            -v /var/run/docker.sock:/var/run/docker.sock \
            --privileged \
            -p 2222:22 \
            debian-ansible-image
    else
        docker run -d --name ansible-container \
            -v /var/run/docker.sock:/var/run/docker.sock \
            --privileged \
            -p 2222:22 \
            debian-ansible-image
    fi

    sleep 5

    sshpass -p toto ssh-copy-id -f -p 2222 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null toto@localhost

    cd $current_dir

    docker cp playbook.yml ansible-container:/home/toto/playbook.yml
    docker cp inventory.yml ansible-container:/home/toto/inventory.yml
    docker cp group_vars ansible-container:/home/toto/group_vars
    docker cp Dockerfile ansible-container:/home/toto/Dockerfile
    docker cp index.html ansible-container:/home/toto/index.html
fi