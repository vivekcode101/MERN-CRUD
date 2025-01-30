provider "aws" {
  region = var.aws_region
}
#################################################
#                Backend Setup                  #
#################################################
terraform {
  backend "s3" {
    bucket                 = "c"
    key                    = "xave"
    region                 = "eu-central-1"
    dynamodb_table         = "clarifruit-xavier-terraform"
    encrypt                = true
    skip_region_validation = true
  }
}