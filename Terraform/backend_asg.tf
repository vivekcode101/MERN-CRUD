module "backend_asg" {
  source = "cloudposse/ec2-autoscale-group/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"
  name                        = "backend_asg"
  image_id                    = "ami-005fc0f236362e99f"
  instance_type               = "t2.micro"
  key_name                    = "linux123"
  security_group_ids          = [module.backend_sg.security_group_id]
  subnet_ids                  = module.three_tier_vpc.private_subnets
  health_check_type           = "EC2"
  min_size                    = 2
  max_size                    = 3
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = false
  user_data_base64            = base64encode(data.template_file.db_private.rendered)

  # All inputs to `block_device_mappings` have to be defined
  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        encrypted             = true
        volume_size           = 8
        delete_on_termination = true
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
        volume_type           = "standard"
      }
    }
  ]

  tags = {
    Terraform   = "backend_ec2"
    Environment = "three_tier"
  }
  target_group_arns = [module.internal_alb.target_groups["backend"].arn]
  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = true
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"
}

resource "aws_autoscaling_attachment" "asg_alb_attachment" {
  autoscaling_group_name = module.backend_asg.autoscaling_group_name
  lb_target_group_arn    = module.internal_alb.target_groups.backend.arn
}