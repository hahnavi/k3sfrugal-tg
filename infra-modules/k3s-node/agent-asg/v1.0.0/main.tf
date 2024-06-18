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

resource "aws_launch_template" "this" {
  name = var.name

  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  update_default_version = true

  dynamic "instance_market_options" {
    for_each = var.create_spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price                      = var.spot_max_price
        spot_instance_type             = "one-time"
        instance_interruption_behavior = "terminate"
      }
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<EOF
#!/bin/bash
export K3S_TOKEN=$(aws ssm get-parameter --name "${var.k3s_token_ssm_parameter_name}" --with-decryption --query "Parameter.Value" --output text)
export INSTALL_K3S_SKIP_SELINUX_RPM=true
curl -sfL https://get.k3s.io | sh -s - agent --server ${var.k3s_server_url}
EOF
  )

  tags = merge({ "Name" = var.name }, var.tags)
}

resource "aws_autoscaling_group" "this" {
  name                = var.name
  vpc_zone_identifier = var.vpc_zone_identifier
  max_size            = 3
  min_size            = 0

  launch_template {
    id = aws_launch_template.this.id
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}
