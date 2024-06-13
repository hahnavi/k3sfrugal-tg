variable "name" {
  description = "Name of the Role"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t4g.nano"
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

variable "k3s_token_ssm_parameter_name" {
  description = "value of the ssm parameter name for the k3s token"
  type        = string
}

variable "k3s_server_url" {
  description = "value of the k3s server url"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
