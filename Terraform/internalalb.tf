module "internal_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "internal"
  vpc_id  = "module.three_tier_vpc.vpc_id"
  subnets = ["module.three_tier_vpc.private_subnets"]

  # Make the ALB internet-facing
  load_balancer_type = "application" # ALB type
  internal           = true          # Internal load balancer

  # Security Group
  security_groups = module.internal_alb_sg.security_group_id


  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn

      forward = {
        target_group_key = "backend"
      }
    }
  }

  target_groups = {
    backend = {
      name_prefix       = "node"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      create_attachment = false
      health_check = {
        path = "/api/cruds"
      }
    }
  }
  depends_on = [module.acm.acm_certificate_arn]
  tags = {
    Terraform   = "internal_alb"
    Environment = "three_tier"
  }
}