#!/bin/bash
export PRIVATE_IP="${PRIVATE_IP}"
# Update and install required packages
sudo apt update -y

# Clone the frontend repository
git clone https://github.com/henokrb/MERN-CRUD.git /home/ubuntu/mern-crud

# Navigate to the server directory
cd /home/ubuntu/mern-crud/server

# Install necessary packages
sudo apt install npm -y
sudo npm install
sudo npm install -g nodemon


sed -i "s|MONGODB_URI=.*|MONGODB_URI=mongodb://${PRIVATE_IP}:27017/MERN|" .env

# Create a systemd service for running the app using nodemon
sudo bash -c 'cat << EOF > /etc/systemd/system/mern-backend.service
[Unit]
Description=MERN Backend Service
After=network.target

[Service]
ExecStart=/usr/bin/nodemon index.js
WorkingDirectory=/home/ubuntu/MERN-CRUD/server
Restart=always
User=root
Environment=PORT=8080

[Install]
WantedBy=multi-user.target
EOF'

# Reload the systemd daemon and start the service
sudo systemctl daemon-reload
sudo systemctl enable mern-backend.service
sudo systemctl start mern-backend.service
