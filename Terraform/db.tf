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

  elastic_gpu_specifications {
    type = "test"
  }

  elastic_inference_accelerator {
    type = "eia1.medium"
  }

  image_id = "ami-005fc0f236362e99f"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"

  key_name = "linux123key"

  license_specification {
    license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
  }

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
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-east-1a"
  }

  vpc_security_group_ids = ["module.db_sg.security_group_id"]

  tag_specifications {
    resource_type = "instance"

  tags = {
    Terraform   = "db_ec2"
    Environment = "three_tier"
  }
  }

  depends_on = [module.backend_sg.security_group_id]
  user_data = filebase64("${path.module}/db.sh")
}