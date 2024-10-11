output "vpc_id" {
  value       = [module.three_tier_vpc.vpc_id]
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = [module.three_tier_vpc.public_subnets]
  description = "The ID of the public subnets"
}

output "private_subnet_ids" {
  value       = [module.three_tier_vpc.private_subnets]
  description = "The ID of the private subnets"
}

output "db_sg_id" {
  value       = [module.db_sg.security_group_id]
  description = "The ID of the db security group"
}

output "backend_sg_id" {
  value       = [module.backend_sg.security_group_id]
  description = "The ID of the db security group"
}

output "internal_alb_sg_id" {
  value       = [module.internal_alb_sg.security_group_id]
  description = "The ID of the internal_alb_sg security group"
}

output "frontend_sg_id" {
  value       = [module.frontend_sg.security_group_id]
  description = "The ID of the frontend_sg security group"
}

output "internet_facing_alb_sg_id" {
  value       = [module.internet_facing_alb_sg.security_group_id]
  description = "The ID of the internet_facing_alb_sg security group"
}

output "db_instance_private_ip" {
  value       = module.db_ec2.private_ip
  description = "Private IP address of the instance"
}

output "backend_asg_group_id" {
  value       = [module.backend_asg.autoscaling_group_id]
  description = "The backend autoscaling group id"
}

output "acm" {
  value       = module.acm.acm_certificate_arn
  description = "The ACM certificate ARN"
}

output "dns" {
  value       = module.internal_alb.dns_name
  description = "The dns of the internal alb"
}

output "finaldns" {
  value       = module.internet_alb.dns_name
  description = "The dns of the intenet facing alb"

}