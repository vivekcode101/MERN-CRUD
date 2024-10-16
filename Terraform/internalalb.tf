module "internal_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "internal"
  vpc_id  = module.three_tier_vpc.vpc_id
  subnets = [module.three_tier_vpc.private_subnets[0], module.three_tier_vpc.private_subnets[1]]

  # Make the ALB internal
  load_balancer_type = "application" # ALB type
  internal           = true          # Internal load balancer

  # Security Group
  security_groups = [module.internal_alb_sg.security_group_id]

  # Disable deletion protection
  enable_deletion_protection = false

  listeners = {
    ex-https = {
      protocol = "HTTP"
      port     = 80

      forward = {
        target_group_key = "backend"
      }
    }

  }

  # Target group configuration for backend
  target_groups = {
    backend = {
      name_prefix       = "node"
      protocol          = "HTTP"
      port              = 8080
      target_type       = "instance"
      create_attachment = false
      health_check = {
        path                = "/api/cruds"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 4
        unhealthy_threshold = 4
      }
    }
  }


  tags = {
    Terraform   = "internal_alb"
    Environment = "three_tier"
  }
}
