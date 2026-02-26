#############################################
# VPC MODULE CALL
#############################################

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

#############################################
# SECURITY GROUP MODULE CALL
#############################################

module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

#############################################
# RDS MODULE CALL
#############################################

module "rds" {
  source = "./modules/rds"

  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_password        = "Strapi12345"
}

#############################################
# ALB MODULE CALL
#############################################

module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

#############################################
# ECS MODULE CALL
#############################################

module "ecs" {
  source = "./modules/ecs"

  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  public_subnet_ids = module.vpc.public_subnet_ids
  ecs_sg_id         = module.security_groups.ecs_sg_id

  blue_tg_arn = module.alb.blue_tg_arn

  ecr_image_url = "811738710312.dkr.ecr.us-east-1.amazonaws.com/gaurav-strapi-task:latest"
  rds_endpoint  = module.rds.rds_endpoint
}

#############################################
# CODEDEPLOY MODULE CALL
#############################################

module "codedeploy" {
  source = "./modules/codedeploy"

  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name

  blue_tg_name  = module.alb.blue_tg_name
  green_tg_name = module.alb.green_tg_name

  listener_arn = module.alb.listener_arn
}