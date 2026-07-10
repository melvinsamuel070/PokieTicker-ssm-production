#!/bin/bash
set -euxo pipefail

##################################################
# System Update
##################################################

apt-get update -y
apt-get upgrade -y

##################################################
# Install Common Utilities
##################################################

apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    jq \
    nginx \
    certbot \
    python3-certbot-nginx \
    ca-certificates \
    gnupg \
    lsb-release

##################################################
# Install Docker
##################################################

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

##################################################
# Install AWS CLI v2
##################################################

cd /tmp

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o awscliv2.zip

unzip -q awscliv2.zip

./aws/install

rm -rf aws awscliv2.zip

##################################################
# Ensure Amazon SSM Agent is Running
##################################################

systemctl enable amazon-ssm-agent || true
systemctl restart amazon-ssm-agent || true

##################################################
# Configure Nginx
##################################################

systemctl enable nginx
systemctl start nginx

##################################################
# Create Deployment Directory
##################################################

mkdir -p /app

chown -R ubuntu:ubuntu /app

##################################################
# Finished
##################################################

echo "Provisioning completed successfully."

sudo apt update

sudo apt install -y git