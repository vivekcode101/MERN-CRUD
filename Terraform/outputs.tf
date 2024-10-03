output "vpc_id" {
  value = module.three_tier_vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value = module.three_tier_vpc.public_subnets
  description = "The ID of the public subnets"  
}

output "private_subnet_ids" {
  value       = module.three_tier_vpc.private_subnets
  description = "The ID of the private subnets"
}

output "backend_sg_id" {
  value = module.backend_sg.security_group_id
  description = "The ID of the db security group"
}

output "internal_alb_sg_id" {
  value = module.internal_alb_sg.security_group_id
  description = "The ID of the internal_alb_sg security group"
}

output "frontend_sg_id" {
  value = module.frontend_sg.security_group_id
  description = "The ID of the frontend_sg security group"
}

output "internet_facing_alb_sg_id" {
  value = module.internet_facing_alb_sg.security_group_id
  description = "The ID of the internet_facing_alb_sg security group"
}