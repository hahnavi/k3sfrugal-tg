resource "aws_ec2_instance_connect_endpoint" "this" {
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
  preserve_client_ip = var.preserve_client_ip
  tags               = merge({ "Name" = var.name }, var.tags)
}
