data "aws_instance" "db_private" {
  filter {
    name   = "tag:Terraform"
    values = ["db_ec2"]
  }
  depends_on = [aws_launch_template.db_private]
}