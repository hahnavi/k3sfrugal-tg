output "id" {
  description = "The ID of the EC2 Connect Endpoint"
  value       = aws_ec2_instance_connect_endpoint.this.id
}

output "subnet_id" {
  description = "The ID of the endpoint subnet"
  value       = aws_ec2_instance_connect_endpoint.this.subnet_id
}

output "security_group_ids" {
  description = "One or more security groups associated with the endpoint"
  value       = aws_ec2_instance_connect_endpoint.this.security_group_ids
}

output "availability_zone" {
  description = "The availability zone of the endpoint"
  value       = aws_ec2_instance_connect_endpoint.this.availability_zone
}

output "vpc_id" {
  description = "The VPC ID in which the endpoint is created"
  value       = aws_ec2_instance_connect_endpoint.this.vpc_id
}
