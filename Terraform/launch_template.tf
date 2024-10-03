locals {
userdata = <<-USERDATA

                 #!/bin/bash
                sudo apt update -y
                git clone https://github.com/henokrb/MERN-CRUD
                # Set up MongoDB
                sudo apt-get install -y gnupg curl
                curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
                echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
                sudo apt-get update
                sudo apt-get install -y mongodb-org
                # Get the private IP of the EC2 instance
                PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

                # Update the mongod.conf file to bind MongoDB to the private IP
                sudo sed -i "s/^  bindIp: .*/  bindIp: $PRIVATE_IP/" /etc/mongod.conf
                sudo systemctl start mongod

                # Import database collections from the repo
                cd MERN-CRUD/server
                mongoimport --db MERN --collection Cruds --file Cruds.json --jsonArray
                USERDATA
}

    module "db_autoscale_group" {
    source = "cloudposse/ec2-autoscale-group/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version = "x.x.x"

    image_id                    = "ami-005fc0f236362e99f"
    instance_type               = "t2.micro"
    security_group_ids          = ["module.db_sg.security_group_id"]
    subnet_ids                  = ["module.three_tier_vpc.private_subnets"]
    health_check_type           = "EC2"
    min_size                    = 2
    max_size                    = 3
    wait_for_capacity_timeout   = "5m"
    associate_public_ip_address = true
    user_data_base64            = base64encode(local.userdata)

  # All inputs to `block_device_mappings` have to be defined
  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        encrypted             = true
        volume_size           = 20
        delete_on_termination = true
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
        volume_type           = "standard"
      }
    }
  ]
  tags = {
    Terraform = "db_asg"
    Environment = "three_tier"
  }
  depends_on = [module.db_sg]
  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}