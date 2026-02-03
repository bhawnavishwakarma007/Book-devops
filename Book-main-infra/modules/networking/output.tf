output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "app_private_subnets" {
  value = [
    aws_subnet.app_private_1.id,
    aws_subnet.app_private_2.id
  ]
}

output "db_private_subnets" {
  value = [
    aws_subnet.db_private_1.id,
    aws_subnet.db_private_2.id
  ]
}

##################################
# Bastion Host Security Group
##################################

output "bastion_public_sg_id" {
  description = "Security Group ID for Bastion Host (public subnet)"
  value       = aws_security_group.bastion_public_sg.id
}

##################################
# Application Load Balancer SG
##################################

output "alb_security_group_id" {
  description = "ALB public security group ID"
  value       = aws_security_group.alb_public_sg.id
}

##################################
# Application EC2 Private SG
##################################

output "app_private_sg_id" {
  description = "Security Group ID for application servers in private subnet"
  value       = aws_security_group.app_private_sg.id
}

# ##################################
# # RDS Private SG
# ##################################

# output "mongodb_private_sg_id" {
#   description = "Security Group ID for RDS in private subnet"
#   value       = aws_security_group.rds_private_sg.id
# }
