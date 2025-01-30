output "id" {
  description = "The ID of the security group"
  value = { for sg_key, sg in aws_security_group.sg : sg_key => sg.id }
}

output "arn" {
  description = "The ARN of the security group"
  value = { for sg_key, sg in aws_security_group.sg : sg_key => sg.arn }
}

output "name" {
  description = "The name of the security group"
  value = { for sg_key, sg in aws_security_group.sg : sg_key => sg.name }
}

output "vpc_id" {
  description = "The VPC ID associated with the security group"
  value = { for sg_key, sg in aws_security_group.sg : sg_key => sg.vpc_id }
}
