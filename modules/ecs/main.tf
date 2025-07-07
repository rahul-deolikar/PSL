provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
  environment         = var.environment
}

module "ecs" {
  source = "./modules/ecs"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
}

module "ec2" {
  source = "./modules/ec2"

  environment         = var.environment
  vpc_id              = module.networking.vpc_id
  public_subnet_ids   = module.networking.public_subnet_ids
  ecs_cluster_name    = module.ecs.ecs_cluster_name
  instance_type       = var.instance_type
  key_name            = var.key_name
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
}
