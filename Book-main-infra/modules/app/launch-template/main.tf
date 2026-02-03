##################################
# app AMI Creation
##################################

resource "aws_ami_from_instance" "app_ami" {
  name                    = var.app_ami_name
  source_instance_id      = var.source_instance_id
  snapshot_without_reboot = false

  tags = {
    Name = var.app_ami_name
  }
}

##################################
# app Launch Template
##################################

resource "aws_launch_template" "app" {
  name                   = var.app_launch_template_name
  description            = var.app_launch_template_description
  image_id               = aws_ami_from_instance.app_ami.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  update_default_version = true

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.app_instance_name
    }
  }
}
