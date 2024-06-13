data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name = "architecture"
    values = ["arm64"]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  private_ip                          = var.private_ip
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name      = var.key_name

  dynamic "instance_market_options" {
    for_each = var.create_spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price                      = var.spot_max_price
        spot_instance_type             = "persistent"
        instance_interruption_behavior = "stop"
      }
    }
  }

  user_data = <<EOF
#!/bin/bash
export K3S_TOKEN=$(aws ssm get-parameter --name "${var.k3s_token_ssm_parameter_name}" --with-decryption --query "Parameter.Value" --output text)
export K3S_DATASTORE_ENDPOINT=$(aws ssm get-parameter --name "${var.k3s_datastore_endpoint_ssm_parameter_name}" --with-decryption --query "Parameter.Value" --output text)
export INSTALL_K3S_SKIP_SELINUX_RPM=true
curl -sfL https://get.k3s.io | sh -s - server --disable=traefik
EOF

  tags = merge({ "Name" = var.name }, var.tags)
}
