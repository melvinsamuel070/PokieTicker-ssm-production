##################################################
# APPLICATION
##################################################

output "instance_id" {
  description = "Application EC2 Instance ID"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "Application EC2 Public IP"
  value       = module.ec2.instance_public_ip
}

##################################################
# NETWORK
##################################################

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.networking.public_subnet_id
}