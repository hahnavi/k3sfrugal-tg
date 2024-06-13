output "public_ip" {
  description = "The public IP address."
  value       = aws_eip.this.public_ip
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_eip.this.private_ip
}

output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "The ARN of the instance"
  value       = aws_instance.this.arn
}
