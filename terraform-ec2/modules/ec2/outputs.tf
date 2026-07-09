output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.this[0].id
}

output "instance_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.this[0].public_ip
}

output "instance_private_ip" {
  description = "EC2 Private IP"
  value       = aws_instance.this[0].private_ip
}