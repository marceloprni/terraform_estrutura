module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "../../modules/security"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  app_port              = var.app_port
  allowed_ingress_cidrs = var.allowed_ingress_cidrs
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "ec2" {
  source = "../../modules/ec2"

  project_name          = var.project_name
  environment           = var.environment
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = module.vpc.private_subnet_ids[0]
  security_group_id     = module.security.ec2_sg_id
  instance_profile_name = module.iam.instance_profile_name
  key_name              = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "APP_ENV=${var.environment}" > /etc/environment
              EOF
}

module "alb" {
  source = "../../modules/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_sg_id
  target_instance_id    = module.ec2.instance_id
  app_port              = var.app_port
}