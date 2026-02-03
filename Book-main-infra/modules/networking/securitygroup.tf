//modules/networking/securitygroup.tf
##################################
# Bastion Host – Public Subnet SG
##################################

resource "aws_security_group" "bastion_public_sg" {
  name        = var.bastion_public_sg_name
  description = "Allow SSH from trusted IPs to bastion (public subnet)"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ip_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.bastion_public_sg_name
    Tier = "public"
  }
}
##################################
# ALB – Public Subnet SG
##################################

resource "aws_security_group" "alb_public_sg" {
  name        = var.alb_public_sg_name
  description = "Allow HTTP/HTTPS traffic from internet to ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb_public_sg_name
    Tier = "public"
  }
}
##################################
# Application Servers – Private Subnet SG
##################################

resource "aws_security_group" "app_private_sg" {
  name        = var.app_private_sg_name
  description = "Allow ALB traffic and bastion SSH to app servers"
  vpc_id      = aws_vpc.vpc.id

  # HTTP from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_public_sg.id]
  }

  # SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.app_private_sg_name
    Tier = "private"
  }
}
##################################
# RDS – Private Subnet SG
##################################

resource "aws_security_group" "rds_private_sg" {
  name        = var.rds_private_sg_name
  description = "Allow DB access from app servers only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.rds_private_sg_name
    Tier = "private"
  }
}
