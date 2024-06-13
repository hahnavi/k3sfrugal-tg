variable "subnet_id" {
  description = "The ID of the subnet in which to create the EC2 Instance Connect Endpoint"
  type        = string
}

variable "security_group_ids" {
  description = "One or more security groups to associate with the endpoint"
  type        = list(string)
}

variable "preserve_client_ip" {
  description = "Indicates whether your client's IP address is preserved as the source"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name to be used as a tag"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
