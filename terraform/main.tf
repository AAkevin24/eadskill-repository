module "secret_manager" {
  source = "./modules/secret_manager"

}

module "iam" {
  source = "./modules/iam"

  secret_arn              = module.secret_manager.secret_arn
  ecs_execution_role_name = "ecs_execution_role"  
  ecs_task_role_name      = "ecs_task_role"      
}

module "s3" {
  source = "./modules/s3" 

  bucket_name = "tf-state-ead-skill-challenge-kevin"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name                = var.vpc_name
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  availability_zones      = var.availability_zones
}

module "rds_instance" {
  source = "./modules/rds"  

  vpc_id               = module.vpc.vpc_id 
  subnet_ids           = module.vpc.private_subnet_ids
  allowed_ips          = ["0.0.0.0/0"]
  db_instance_name     = var.db_instance_name
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name              = "eadskilldb"
  db_username          = var.db_username
  db_password          = var.db_password
  multi_az             = var.multi_az
  backup_retention_days = var.backup_retention_days
}

module "load_balancer" {
  source = "./modules/load_balancer"
  
  lb_name           = var.lb_name
  subnet_ids        = module.vpc.public_subnet_ids
  allowed_ips       = ["0.0.0.0/0"]
  vpc_id            = module.vpc.vpc_id
  target_group_name = var.target_group_name
}

module "route53" {
  source = "./modules/route53"

  zone_name              = var.zone_name
  record_name            = var.record_name
  load_balancer_dns_name = module.load_balancer.load_balancer_dns_name
}

module "ecs" {
  source = "./modules/ecs"
  
  db_instance_endpoint    = module.rds_instance.db_instance_endpoint
  db_secret_arn           = module.secret_manager.secret_arn
  cluster_name            = "ead-skill-cluster"
  cluster_id              = module.ecs.cluster_id
  task_definition_name    = "ead-skill-task"
  execution_role_arn      = module.iam.execution_role_arn
  task_role_arn           = module.iam.task_role_arn
  db_container_name       = "populate-container"  
  image_url_backend       = var.image_url_backend
  app_container_name      = "app-container"  
  image_url_populate      = var.image_url_populate
  service_name            = "ead-ecs-service"
  desired_count           = 2
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  allowed_ips             = ["0.0.0.0/0"]
}
