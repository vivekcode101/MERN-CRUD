resource "aws_launch_template" "db_private" {
  name = "db_private"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true


  image_id = "ami-005fc0f236362e99f"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"

  key_name = "linux123key"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = module.three_tier_vpc.private_subnets[0]
    security_groups             = [module.db_sg.security_group_id]

  }

  placement {
    availability_zone = "us-east-1a"
  }


  tag_specifications {
    resource_type = "instance"

    tags = {
      Terraform   = "db_ec2"
      Environment = "three_tier"
    }
  }

  depends_on = [module.db_sg.security_group_id]
  user_data  = filebase64("${path.module}/db.sh")
}