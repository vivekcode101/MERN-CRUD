module "internet_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "internet"
  vpc_id  = module.three_tier_vpc.vpc_id
  subnets = [module.three_tier_vpc.public_subnets[0], module.three_tier_vpc.public_subnets[1]]


  load_balancer_type = "application"
  internal           = false


  security_groups = [module.internet_facing_alb_sg.security_group_id]


  enable_deletion_protection = false


  listeners = {
    ex-https = {
      certificate_arn = module.acm.acm_certificate_arn
      protocol        = "HTTPS"
      port            = 443

      forward = {
        target_group_key = "frontend"
      }
    }

  }

  target_groups = {
    frontend = {
      name_prefix       = "npm"
      protocol          = "HTTP"
      port              = 3000
      target_type       = "instance"
      create_attachment = false
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
      }
    }
  }
  tags = {
    Terraform   = "internal_alb"
    Environment = "three_tier"
  }
}
