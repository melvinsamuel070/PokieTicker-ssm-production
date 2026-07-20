 #!/bin/bash
# set -euxo pipefail

# ##################################################
# # System Update
# ##################################################

# apt-get update -y
# apt-get upgrade -y

# ##################################################
# # Install Common Utilities
# ##################################################

# apt-get install -y \
#     curl \
#     wget \
#     unzip \
#     git \
#     jq \
#     nginx \
#     certbot \
#     python3-certbot-nginx \
#     ca-certificates \
#     gnupg \
#     lsb-release

# ##################################################
# # Install Docker
# ##################################################

# install -m 0755 -d /etc/apt/keyrings

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
# | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# chmod a+r /etc/apt/keyrings/docker.gpg

# echo \
# "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
# https://download.docker.com/linux/ubuntu \
# $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
# | tee /etc/apt/sources.list.d/docker.list > /dev/null

# apt-get update -y

# apt-get install -y \
#     docker-ce \
#     docker-ce-cli \
#     containerd.io \
#     docker-buildx-plugin \
#     docker-compose-plugin

# systemctl enable docker
# systemctl start docker

# usermod -aG docker ubuntu

# ##################################################
# # Install AWS CLI v2
# ##################################################

# cd /tmp

# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
# -o awscliv2.zip

# unzip -q awscliv2.zip

# ./aws/install

# rm -rf aws awscliv2.zip

# ##################################################
# # Ensure Amazon SSM Agent is Running
# ##################################################

# systemctl enable amazon-ssm-agent || true
# systemctl restart amazon-ssm-agent || true

# ##################################################
# # Configure Nginx — PokieTicker reverse proxy
# #
# # Routes:
# #   /api/ -> backend container directly (health checks etc)
# #   /     -> frontend container (static SPA)
# ##################################################

# cat > /etc/nginx/sites-available/pokieticker << 'NGINXEOF'
# server {
#     listen 80;
#     listen [::]:80;

#     server_name _;

#     location /api/ {
#         proxy_pass http://127.0.0.1:8000/api/;
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto $scheme;
#     }

#     location / {
#         proxy_pass http://127.0.0.1:7777/;
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto $scheme;
#     }
# }
# NGINXEOF

# ln -sf /etc/nginx/sites-available/pokieticker /etc/nginx/sites-enabled/pokieticker
# rm -f /etc/nginx/sites-enabled/default

# nginx -t
# systemctl enable nginx
# systemctl restart nginx

# ##################################################
# # Create Deployment Directory
# #
# # Must match APP_DIR used by the GitHub Actions deploy
# # step (currently /home/ubuntu/app).
# ##################################################

# mkdir -p /home/ubuntu/app
# chown -R ubuntu:ubuntu /home/ubuntu/app

# ##################################################
# # Finished
# #
# # Marker file lets the GitHub Actions pipeline poll
# # for real completion instead of guessing with a fixed
# # sleep.
# ##################################################

# touch /home/ubuntu/.provisioning-complete
# chown ubuntu:ubuntu /home/ubuntu/.provisioning-complete

# echo "Provisioning completed successfully."


































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
# Configure Nginx — PokieTicker reverse proxy (HOST-LEVEL)
#
# This runs on the EC2 host itself, listening on the
# public port 80. It is NOT the same as
# frontend/nginx.conf, which runs INSIDE the frontend
# Docker container on port 7777 and handles the
# /PokieTicker/ SPA routing + the / -> /PokieTicker/
# redirect.
#
# Routes:
#   /api/ -> backend container directly (127.0.0.1:8000)
#   /     -> frontend container (127.0.0.1:7777)
##################################################

cat > /etc/nginx/sites-available/pokieticker << 'NGINXEOF'
server {
    listen 80;
    listen [::]:80;

    server_name _;

    location /api/ {
        proxy_pass http://127.0.0.1:8000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        proxy_pass http://127.0.0.1:7777/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINXEOF 

ln -sf /etc/nginx/sites-available/pokieticker /etc/nginx/sites-enabled/pokieticker
rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl enable nginx
systemctl restart nginx

##################################################
# Create Deployment Directory
#
# Must match APP_DIR used by the GitHub Actions deploy
# step (currently /home/ubuntu/app).
##################################################

mkdir -p /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

##################################################
# Finished
#
# Marker file lets the GitHub Actions pipeline poll
# for real completion instead of guessing with a fixed
# sleep.
##################################################

touch /home/ubuntu/.provisioning-complete
chown ubuntu:ubuntu /home/ubuntu/.provisioning-complete

echo "Provisioning completed successfully."
