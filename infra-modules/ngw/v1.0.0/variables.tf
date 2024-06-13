variable "name" {
  description = "Name of the NGW"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID to create the ENI in"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "A list of private IPs to associate with the ENI"
  type        = string
  default     = null
}

variable "security_groups" {
  description = "A list of security groups to associate with the ENI"
  type        = list(string)
  default     = null
}

variable "private_route_table_id" {
  description = "The ID of the routing table"
  type        = string
  default     = null
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-001211b1bb7148de3"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t4g.nano"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "create_spot_instance" {
  description = "Depicts if the instance is a spot instance"
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "The maximum price to request on the spot market. Defaults to on-demand price"
  type        = string
  default     = null
}

variable "spot_instance_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`"
  type        = string
  default     = "persistent"
}

variable "spot_instance_interruption_behavior" {
  description = "The behavior when a Spot Instance is interrupted. Valid values include `hibernate`, `stop`, `terminate`. The default is `stop`"
  type        = string
  default     = "stop"
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead"
  type        = string
  default     = <<EOF
#!/bin/bash
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

dnf install iptables-services haproxy python3-certbot -y
systemctl enable iptables --now

iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
iptables -F FORWARD
iptables save
EOF
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
