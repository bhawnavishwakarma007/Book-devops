//env/dev/main.tf
##################################
# NETWORKING (VPC + SUBNETS + SG)
##################################

module "networking" {
  source = "../../modules/networking"

  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "book-vpc"

  az_1 = "us-east-1a"
  az_2 = "us-east-1b"

  public_subnet_1_cidr = "10.0.1.0/24"
  public_subnet_2_cidr = "10.0.2.0/24"

  app_private_subnet_1_cidr = "10.0.3.0/24"
  app_private_subnet_2_cidr = "10.0.4.0/24"

  db_private_subnet_1_cidr = "10.0.5.0/24"
  db_private_subnet_2_cidr = "10.0.6.0/24"

  admin_ip_cidr = ["175.101.32.52/32"]

  bastion_public_sg_name = "book-bastion-sg"
  alb_public_sg_name     = "book-alb-sg"
  app_private_sg_name    = "book-app-sg"
  rds_private_sg_name    = "book-rds-sg"
}



##################################
# BASTION HOST
##################################

module "bastion" {
  source = "../../modules/bation"

  ami               = "ami-00ca32bbc84273381"
  instance_type     = "t2.micro"
  key_name          = "book-key"
  subnet_id         = module.networking.public_subnets[0]
  security_group_id = module.networking.bastion_public_sg_id
}

##################################
# app EC2 (AMI BUILDER)
##################################

module "app_ec2" {
  source = "../../modules/app/ec2"

  ami           = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  key_name      = "book-key"

  subnet_id         = module.networking.app_private_subnets[0]
  security_group_id = module.networking.app_private_sg_id

  app_server_name = "app-ec2"
}

##################################
# app LAUNCH TEMPLATE (AMI + LT)
##################################

module "app_launch_template" {
  source = "../../modules/app/launch-template"

  app_ami_name       = "app-ami"
  source_instance_id = module.app_ec2.app_instance_id

  app_launch_template_name        = "app-lt"
  app_launch_template_description = "Launch template for app ASG"

  instance_type     = "t2.micro"
  key_name          = "us-east-1"
  security_group_id = module.networking.app_private_sg_id

  app_instance_name = "app-lt"
}

##################################
# app LOAD BALANCER
##################################

module "app_alb" {
  source = "../../modules/app/loadbalancer-app"

  vpc_id                = module.networking.vpc_id
  app_tg_name           = "app-tg"
  app_lb_name           = "app-alb"
  public_subnet_ids     = module.networking.public_subnets
  alb_security_group_id = module.networking.alb_security_group_id
}
##################################
# app ASG
##################################

module "app_asg" {
  source = "../../modules/app/asg"

  app_asg_name              = "app-asg"
  app_scale_out_policy_name = "app-scale-out"

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  launch_template_id = module.app_launch_template.app_launch_template_id
  private_subnet_ids = module.networking.app_private_subnets
  target_group_arn   = module.app_alb.app_tg_arn
}
