data "template_file" "db_private" {
  template = templatefile("${path.module}/backend.tpl", {
    PRIVATE_IP = module.db_ec2.private_ip[0]
  })
  
}

data "template_file" "frontend_userdata" {
  template = templatefile("${path.module}/frontend.tpl", {
    INTERNAL_ALB_DNS = module.internal_alb.dns_name
  })

}