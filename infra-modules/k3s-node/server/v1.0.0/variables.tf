variable "name" {
  description = "Name of the NGW"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t4g.nano"
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
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

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "k3s_token_ssm_parameter_name" {
  description = "value of the ssm parameter name for the k3s token"
  type        = string
}

variable "k3s_datastore_endpoint_ssm_parameter_name" {
  description = "value of the ssm parameter name for the datastore endpoint"
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
