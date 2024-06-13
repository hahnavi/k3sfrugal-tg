resource "aws_network_interface" "this" {
  subnet_id         = var.subnet_id
  private_ips       = [var.private_ip]
  security_groups   = var.security_groups
  source_dest_check = false
  tags              = merge({ "Name" = var.name }, var.tags)
}

resource "aws_eip" "this" {
  network_interface = aws_network_interface.this.id
  tags              = merge({ "Name" = var.name }, var.tags)
}

resource "aws_route" "routes" {
  route_table_id = var.private_route_table_id

  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.this.id
}

resource "aws_instance" "this" {
  depends_on = [aws_eip.this]

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  dynamic "instance_market_options" {
    for_each = var.create_spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price                      = var.spot_max_price
        spot_instance_type             = var.spot_instance_type
        instance_interruption_behavior = var.spot_instance_interruption_behavior
      }
    }
  }

  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.this.id
    delete_on_termination = false
  }

  user_data = var.user_data

  tags = merge({ "Name" = var.name }, var.tags)
}
