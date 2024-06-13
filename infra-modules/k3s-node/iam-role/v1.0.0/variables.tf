variable "name" {
  description = "Name of the Role"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = null
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
