#!/bin/bash

# Update and install required packages
sudo apt-get update -y
sudo apt-get install -y git curl

# Install Node.js and npm
sudo apt install npm -y

# Clone the frontend repository
git clone https://github.com/henokrb/MERN-CRUD.git /home/ubuntu/mern-crud
cd /home/ubuntu/mern-crud/client

# Install dependencies
sudo npm install

# Replace '/api/cruds/' with the internal ALB DNS in the frontend files
INTERNAL_ALB_DNS="${terraform output -raw dns}"
sed -i "s|/api/cruds|https://${INTERNAL_ALB_DNS}/api/cruds/|g" src/components/cruds/*.js

# Build the frontend
sudo npm run build
sudo npm install -g serve

# Create a systemd service to start the frontend automatically
sudo bash -c 'cat <<EOT > /etc/systemd/system/frontend.service
[Unit]
Description=Frontend Service
After=network.target

[Service]
ExecStart=/usr/bin/serve -s build
WorkingDirectory=/home/ubuntu/mern-crud/client/build
Restart=always
User=root
Environment=PATH=/usr/bin:/usr/local/bin

[Install]
WantedBy=multi-user.target
EOT'

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Enable and start the frontend service
sudo systemctl enable frontend.service
sudo systemctl start frontend.service
