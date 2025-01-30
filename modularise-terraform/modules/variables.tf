variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "security_groups" {
  description = "A map of security groups to create"
  type = map(object({
    name        = string
    description = string
    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
  default = {}
}


variable "tags" {
  description = "A map of tags to assign to all security groups"
  type        = map(string)
  default     = {}

}

variable "aws_region" {
  
}