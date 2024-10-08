#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    BASE_SSH_PORT=2222
    BASE_WEB_PORT=8080
    BASE_DB_PORT=33060
    NUM_CONTAINERS=2
    USERNAME=toto
    PASSWORD=toto

    for i in $(seq 1 $NUM_CONTAINERS); do
        SSH_PORT=$((BASE_SSH_PORT + i - 1))
        ssh-keygen -R "[localhost]:${SSH_PORT}"
    done

    for i in $(seq 1 $NUM_CONTAINERS); do
        CONTAINER_NAME="debian-full-$i"
        SSH_PORT=$((BASE_SSH_PORT + i - 1))
        WEB_PORT=$((BASE_WEB_PORT + i - 1))
        DB_PORT=$((BASE_DB_PORT + i - 1))

        if docker ps --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
            echo "Container '${CONTAINER_NAME}' is already running."
        else
            if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
                echo "Starting existing container '${CONTAINER_NAME}'..."
                docker start "${CONTAINER_NAME}"
            else
                echo "Running new container '${CONTAINER_NAME}'..."
                docker run -d \
                    -p ${SSH_PORT}:22 \
                    -p ${WEB_PORT}:80 \
                    -p ${DB_PORT}:3306 \
                    --name "${CONTAINER_NAME}" \
                    basilelt/debian-full:latest
            fi
        fi
    done

    echo "Waiting for containers to start..."
    sleep 5

    echo "Container IPs:"
    for i in $(seq 1 $NUM_CONTAINERS); do
        CONTAINER_NAME="debian-full-$i"
        IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER_NAME})
        SSH_PORT=$((BASE_SSH_PORT + i - 1))
        echo "${CONTAINER_NAME}: IP=${IP}, SSH Port=${SSH_PORT}"
    done

    # SSH key copy and sudoers configuration
    echo "Copying SSH key to containers and configuring sudoers..."
    for i in $(seq 1 $NUM_CONTAINERS); do
        SSH_PORT=$((BASE_SSH_PORT + i - 1))
        CONTAINER_NAME="debian-full-$i"
        echo "Configuring container ${CONTAINER_NAME} on port ${SSH_PORT}..."
        
        # Copy SSH key
        sshpass -p "${PASSWORD}" ssh-copy-id -f -p ${SSH_PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USERNAME}@localhost
        
        # Create sudoers file for ${USERNAME}
        echo "Creating sudoers file for ${USERNAME}..."
        ssh -p ${SSH_PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USERNAME}@localhost "echo '${PASSWORD}' | sudo -S bash -c 'echo \"${USERNAME} ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/${USERNAME} && chmod 440 /etc/sudoers.d/${USERNAME}'"
        
        # Verify the sudoers file
        echo "Verifying sudoers file..."
        ssh -p ${SSH_PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${USERNAME}@localhost "sudo cat /etc/sudoers.d/${USERNAME}"
    done
fi