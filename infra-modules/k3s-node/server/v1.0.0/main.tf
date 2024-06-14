locals {
  k3s_token_ssm_parameter_name              = "/${var.project_name}/${var.env}/k3s/token"
  k3s_datastore_endpoint_ssm_parameter_name = "/${var.project_name}/${var.env}/k3s/datastore_endpoint"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_ssm_parameter" "k3s_datastore_endpoint" {
  count = var.bootsrapper ? 1 : 0

  name  = local.k3s_datastore_endpoint_ssm_parameter_name
  type  = "SecureString"
  value = var.K3S_DATASTORE_ENDPOINT
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  private_ip             = var.private_ip
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

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
${var.bootsrapper ? <<EOF
export K3S_DATASTORE_ENDPOINT="$(aws ssm get-parameter --name "${aws_ssm_parameter.k3s_datastore_endpoint[0].name}" --with-decryption --query "Parameter.Value" --output text)"
EOF
  : <<EOF
fail_count=0
while true; do
  export K3S_TOKEN=$(aws ssm get-parameter --name "${local.k3s_token_ssm_parameter_name}" --with-decryption --query "Parameter.Value" --output text)
  export K3S_DATASTORE_ENDPOINT="$(aws ssm get-parameter --name "${local.k3s_datastore_endpoint_ssm_parameter_name}" --with-decryption --query "Parameter.Value" --output text)"

  if [ -n "$K3S_TOKEN" ] && [ -n "$K3S_DATASTORE_ENDPOINT" ]; then
    break
  fi

  ((fail_count++))

  if [ $((fail_count % 5)) -eq 0 ]; then
    interval=300
  else
    interval=60
  fi

  sleep $interval
done
EOF
  }
export INSTALL_K3S_SKIP_SELINUX_RPM=true
curl -sfL https://get.k3s.io | sh -s - server --disable=traefik

${var.bootsrapper ? <<EOF
if [ $? -eq 0 ]; then
  aws ssm put-parameter --name "${local.k3s_token_ssm_parameter_name}" --value "$(cat /var/lib/rancher/k3s/server/token)" --type "SecureString" --overwrite
fi
EOF
: ""}
EOF

tags = merge({ "Name" = var.name }, var.tags)
}
