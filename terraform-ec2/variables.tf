####################################################
# AWS
####################################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

####################################################
# PROJECT
####################################################

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "pokieticker"
}

####################################################
# EC2
####################################################

variable "instance_name" {
  description = "Application EC2 Name"
  type        = string
  default     = "pokieticker-app"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
  default     = "git1"
}

####################################################
# AMI
####################################################

variable "architecture" {
  description = "AMI Architecture"
  type        = string
  default     = "x86"

  validation {
    condition     = contains(["x86", "arm"], var.architecture)
    error_message = "architecture must be x86 or arm."
  }
}

####################################################
# NETWORK
####################################################

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
  default     = "us-east-1a"
}

####################################################
# SECURITY
####################################################

variable "allowed_ssh_ip" {
  description = "Your public IP with /32"

  type = string

  default = "105.112.11.193/32"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}