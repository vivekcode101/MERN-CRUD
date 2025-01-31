#!/bin/bash
# Update the system
sudo apt update -y

# Clone the MERN-CRUD repository
git clone https://github.com/vivekcode101/MERN-CRUD


# Set up MongoDB
sudo apt-get install -y gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org


# Start MongoDB service
sudo systemctl start mongod

# Get the private IP of the EC2 instance
TOKEN=$(curl -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" http://169.254.169.254/latest/api/token)
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)

# Update bindIp in mongod.conf to bind to the private IP
sudo sed -i "/^  bindIp: 127.0.0.1/s/$/,$PRIVATE_IP/" /etc/mongod.conf

# Restart MongoDB service to apply changes
sudo systemctl restart mongod


# Import database collections from the repo
cd MERN-CRUD/server
mongoimport --db MERN --collection Cruds --file Cruds.json --jsonArray
