##################################################
# AMI
##################################################

variable "ami_id" {
  description = "Ubuntu AMI"
  type        = string
}

##################################################
# INSTANCE
##################################################

variable "instance_name" {
  description = "EC2 Name"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

##################################################
# NETWORK
##################################################

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups"
  type        = list(string)
}

##################################################
# SSH KEY (OPTIONAL)
##################################################

variable "key_name" {
  description = "AWS Key Pair"
  type        = string
}