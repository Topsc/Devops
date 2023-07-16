terraform { 
    backend "local" { } 
}



provider "aws" {
  region     = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

# VPC and Networking
module "techscrum-vpc-network" {
  source = "./modules/Networking"

}

module "techscrum-ecs" {
  source = "./modules/ECS"
  name="techscrum-uat-ecs"
}



# Task Definition
module "techscrumTaskDef" {
  source = "./modules/TaskDefination"
  image_name = "508023426757.dkr.ecr.ap-southeast-2.amazonaws.com/techscrum-linda:latest"
}

# Service
module "techscrumService" {
  source = "./modules/ECS-Service"
  task-def-family = module.techscrumTaskDef.family
  ecs-cluster-id = module.techscrum-ecs.ecs_id
  sg_id = module.my-sg.id
  subnet-ids = module.techscrum-vpc-network.public_subnet_ids
  
}
# Security Group
module "my-sg" {
  source = "./modules/SecurityGroup"
  vpc_id = module.techscrum-vpc-network.vpc-id
}


















