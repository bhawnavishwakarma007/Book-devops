##################################
# AMI Inputs
##################################

variable "app_ami_name" {
  type = string
}

variable "source_instance_id" {
  description = "app EC2 instance ID used to create AMI"
  type        = string
}

##################################
# Launch Template Inputs
##################################

variable "app_launch_template_name" {
  type = string
}

variable "app_launch_template_description" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_id" {
  description = "app EC2 security group ID"
  type        = string
}

##################################
# Tags
##################################

variable "app_instance_name" {
  type = string
}
