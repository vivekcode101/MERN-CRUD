module "db_ec2" {
  source  = "clouddrove/ec2/aws"
  version = "2.0.3"

  name = "db_ec2"

  ## security-group
  vpc_id = module.three_tier_vpc.vpc_id
  sg_ids = [module.db_sg.security_group_id]

  #instance
  instance_count              = 1
  ami                         = "ami-005fc0f236362e99f"
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  assign_eip_address          = false

  #Networking
  subnet_ids = tolist(module.three_tier_vpc.public_subnets)

  #Keypair
  key_name = "linux123"


  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 8
      delete_on_termination = true
    }
  ]

  #EBS Volume
  ebs_volume_enabled = false
  #Tags
  instance_tags = { "Terraform" = "db_ec2" }

  depends_on = [module.db_sg.security_group_id]
  user_data  = filebase64("${path.module}/db.sh")

}