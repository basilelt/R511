#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function cleanup() {
    echo "Cleaning up..."
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    BASE_SSH_PORT=2222
    NUM_CONTAINERS=10

    for i in $(seq 1 $NUM_CONTAINERS); do
        CONTAINER_NAME="debian-full-$i"
        SSH_PORT=$((BASE_SSH_PORT + i - 1))

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
fi