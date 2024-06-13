output "id" {
  description = "value of the id"
  value       = aws_launch_template.this.id
}

output "arn" {
  description = "value of the arn"
  value       = aws_launch_template.this.arn
}

output "min_size" {
  description = "value of the min_size"
  value       = aws_autoscaling_group.this.min_size
}

output "max_size" {
  description = "value of the max_size"
  value       = aws_autoscaling_group.this.max_size
}
