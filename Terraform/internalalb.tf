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
      certificate_arn = module.acm.acm_certificate_arn
      protocol        = "HTTPS"

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
  depends_on = [module.three_tier_vpc, module.acm.acm_certificate_arn]
  tags = {
    Terraform   = "internal_alb"
    Environment = "three_tier"
  }
}