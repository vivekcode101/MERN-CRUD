resource "aws_security_group" "sg" {
  # Use dynamic names for each security group from the root module
  for_each = var.security_groups  # Iterate over the security groups passed from the root module
  
  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id

  # Create ingress rules dynamically for each security group
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Create egress rules dynamically for each security group
  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  # Apply tags to each security group
  tags = merge(var.tags, { Name = each.value.name })
}
