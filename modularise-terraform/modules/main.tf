module "security_groups" {
  source          = "./security_group" # Path to the security group module
  vpc_id          = var.vpc_id
  security_groups = var.security_groups
  tags            = var.tags
}