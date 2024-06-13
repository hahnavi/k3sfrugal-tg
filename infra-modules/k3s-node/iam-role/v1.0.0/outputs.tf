output "role_id" {
  description = "The id of the role"
  value       = aws_iam_role.this.id
}

output "instance_profile" {
  description = "The name of the instance profile"
  value       = aws_iam_instance_profile.this.name
}
