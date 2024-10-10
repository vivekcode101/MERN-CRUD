#!/bin/bash

# Update and install required packages
sudo apt-get update -y
sudo apt-get install -y git curl

# Install Node.js and npm
sudo apt install npm -y

# Clone the frontend repository
git clone https://github.com/henokrb/MERN-CRUD.git /home/ubuntu/mern-crud

# Navigate to the server directory
cd /home/ubuntu/mern-crud/server

# Install necessary packages
sudo apt install npm -y
sudo npm install
sudo npm install -g nodemon

# Replace the MONGODB_URI in the .env file with the database's private IP
DB_PRIVATE_IP="${terraform output -raw db_instance_private_ip}"  # This will be passed in as a variable
sed -i "s|MONGODB_URI=.*|MONGODB_URI=mongodb://$DB_PRIVATE_IP:27017/MERN|" .env

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
Environment=MONGODB_URI=mongodb://'"$DB_PRIVATE_IP"':27017/MERN

[Install]
WantedBy=multi-user.target
EOF'

# Reload the systemd daemon and start the service
sudo systemctl daemon-reload
sudo systemctl enable mern-backend.service
sudo systemctl start mern-backend.service
