#!/bin/bash

export INTERNAL_ALB_DNS="${INTERNAL_ALB_DNS}"

# Update and install required packages
sudo apt-get update -y
sudo apt-get install -y git curl

# Install Node.js and npm
sudo apt install npm -y

# Clone the frontend repository
git clone https://github.com/vivekcode101/MERN-CRUD /home/ubuntu/mern-crud
cd /home/ubuntu/mern-crud/client

# Replace '/api/cruds/' with the internal ALB DNS in the frontend files
sudo sed -i "s|"proxy": ""|"proxy": "${INTERNAL_ALB_DNS}"|g" /home/ubuntu/mern-crud/client/package.json

# Install dependencies
sudo npm install

# Build the frontend
sudo npm run build

# Create a systemd service to start the frontend automatically
sudo bash -c 'cat <<EOT > /etc/systemd/system/frontend.service
[Unit]
Description=Frontend Service
After=network.target

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/home/ubuntu/mern-crud/client
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
