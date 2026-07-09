##################################################
# NETWORKING
##################################################

module "networking" {

  source = "./modules/networking"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

##################################################
# APPLICATION SERVER
##################################################

module "ec2" {

  source = "./modules/ec2"

  ami_id         = local.ami_id
  instance_name  = var.instance_name
  instance_type  = var.instance_type
  instance_count = var.instance_count
  key_name       = var.key_name

  subnet_id = module.networking.public_subnet_id

  security_group_ids = [
    module.networking.application_security_group_id
  ]
}