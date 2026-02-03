variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "app_private_subnet_1_cidr" {
  type = string
}

variable "app_private_subnet_2_cidr" {
  type = string
}

variable "db_private_subnet_1_cidr" {
  type = string
}

variable "db_private_subnet_2_cidr" {
  type = string
}

variable "az_1" {
  type = string
}

variable "az_2" {
  type = string
}


##################################
# Security Group Names
##################################

variable "admin_ip_cidr" {
  description = "Admin public IPs allowed for SSH"
  type        = list(string)
}

variable "bastion_public_sg_name" {
  description = "Security Group name for Bastion host (public subnet)"
  type        = string
}
variable "alb_public_sg_name" {
  description = "Security Group name for ALB (public subnet)"
  type        = string
}
variable "app_private_sg_name" {
  description = "Security Group name for Application servers (private subnet)"
  type        = string
}
variable "rds_private_sg_name" {
  description = "Security Group name for RDS database (private subnet)"
  type        = string
}
