output "sg_id" {
  description = "The ID of the public ALB security group"
  value       = module.security_groups.id
}

output "sg_arn" {
  description = "The ARN of the public ALB security group"
  value       = module.security_groups.arn
}

output "sg_name" {
  description = "The name of the public ALB security group"
  value       = module.security_groups.name
}
