#!/usr/bin/env bash

#set -euox pipefail # Uncomment for debugging
set -euo pipefail # Comment for debugging

IFS=$'\n\t'

# Function to clean up the script
function cleanup() {
    echo "Cleaning up..."
    cd $current_dir
    rm -rf tempdir
}

# Run the script
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap cleanup EXIT

    # Get the full path of the script's directory
    current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "Current directory (full path): $current_dir"
    cd "$current_dir"

    # Parent directory of the website docker files
    mkdir -p tempdir
    cd tempdir

    # Create Dockerfile
    cat > Dockerfile <<EOF
#Dockerfile
FROM python:3.12-slim AS python3.12_base_slim

# Create app directory
RUN mkdir -p /home/myapp
WORKDIR /home/myapp

# Install Flask and Gunicorn
RUN pip install --no-cache-dir flask==3.0.3 gunicorn==23.0.0

# Copy the Flask app files to the container
COPY Flask_app/ .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8080", "flask_app:sample"]
EOF

    # Create .dockerignore
    cat > .dockerignore <<EOF
.git
.DS_Store
.venv
__pycache__
EOF

    # Build the Docker image
    # -t: Tag the image with the name "tp1_blt"
    # -f: Use the Dockerfile in the current directory
    # ..: Go to the parent directory (where Flask_app is)
    docker build -t tp1_blt:latest -f Dockerfile ..

    # Stop the container if it's running
    if docker ps -q -f name=run_tp1_blt | grep -q .; then
        echo "Stopping existing container..."
        docker stop run_tp1_blt
    fi

    # Remove the container if it exists
    if docker ps -aq -f name=run_tp1_blt | grep -q .; then
        echo "Removing existing container..."
        docker rm run_tp1_blt
    fi

    # Run the Docker container
    echo "Starting new container..."
    docker run -d -p 8080:8080 --name run_tp1_blt tp1_blt

    # List all Docker containers
    docker ps -a
fi
