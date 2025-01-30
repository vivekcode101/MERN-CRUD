variable "security_groups" {
  description = "A map of security group configurations"
  type = map(object({
    name          = string
    description   = string
    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules  = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "vpc_id" {
  description = "The VPC ID where the security groups will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the security groups"
  type        = map(string)
  default     = {}
}
