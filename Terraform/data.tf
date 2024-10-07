data "aws_instance" "db_private" {
  filter {
    name   = "tag:Terraform"
    values = ["db_ec2"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"] # Add this to filter only running instances
  }

  # Add any other filters as needed
  depends_on = [module.db_ec2]
}
