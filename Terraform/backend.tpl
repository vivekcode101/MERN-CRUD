#!/bin/bash
export PRIVATE_IP=${PRIVATE_IP}
# Update and install required packages
sudo apt update -y

# Clone the frontend repository
git clone https://github.com/vivekcode101/MERN-CRUD /home/ubuntu/mern-crud

# Navigate to the server directory
cd /home/ubuntu/mern-crud/server

# Install necessary packages
sudo apt install npm -y
sudo npm install
sudo npm install -g nodemon


sudo sed -i "s|MONGODB_URI=.*|MONGODB_URI=mongodb://${PRIVATE_IP}:27017/MERN|" .env

# Create nodemon.sh script in the server folder
sudo bash -c 'cat << EOF > /home/ubuntu/mern-crud/server/nodemon.sh
#!/bin/bash
nodemon index.js
EOF'

# Make nodemon.sh executable
sudo chmod +x /home/ubuntu/mern-crud/server/nodemon.sh

# Create the systemd service file
sudo bash -c 'cat << EOF > /etc/systemd/system/mern-backend.service
[Unit]
Description=Run nodemon for MERN-CRUD server
After=network.target

[Service]
ExecStart=/home/ubuntu/mern-crud/server/nodemon.sh
Restart=on-failure
RestartSec=3
User=ubuntu
WorkingDirectory=/home/ubuntu/mern-crud/server

[Install]
WantedBy=multi-user.target
EOF'

# Reload the systemd daemon and start the service
sudo systemctl daemon-reload
sudo systemctl enable mern-backend.service
sudo systemctl start mern-backend.service