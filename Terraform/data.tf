data "aws_instance" "db_private" {
  filter {
    name   = "tag:Terraform"
    values = ["db_ec2"]
  }
}