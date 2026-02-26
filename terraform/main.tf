#############################################
# NETWORK MODULE
#############################################

module "network" {
  source = "./modules/network"

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_1_cidr  = "10.0.1.0/24"
  public_subnet_2_cidr  = "10.0.2.0/24"
  private_subnet_1_cidr = "10.0.3.0/24"
  private_subnet_2_cidr = "10.0.4.0/24"
}

#############################################
# RDS MODULE
#############################################

module "rds" {
  source             = "./modules/rds"
  private_subnet_ids = module.network.private_subnet_ids
  rds_sg_id          = module.network.rds_sg_id
}

#############################################
# ALB MODULE
#############################################

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.network.alb_sg_id
}

#############################################
# ECS MODULE
#############################################

module "ecs" {
  source            = "./modules/ecs"
  public_subnet_ids = module.network.public_subnet_ids
  ecs_sg_id         = module.network.ecs_sg_id
  rds_endpoint      = module.rds.rds_endpoint
  blue_tg_arn       = module.alb.blue_tg_arn

  ecr_image_url = "811738710312.dkr.ecr.us-east-1.amazonaws.com/gaurav-strapi-task:latest"
}

#############################################
# CODEDEPLOY MODULE
#############################################

module "codedeploy" {
  source        = "./modules/codedeploy"
  cluster_name  = module.ecs.cluster_name
  service_name  = module.ecs.service_name
  blue_tg_name  = module.alb.blue_tg_name
  green_tg_name = module.alb.green_tg_name
  listener_arn  = module.alb.listener_arn
}