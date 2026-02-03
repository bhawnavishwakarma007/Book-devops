output "app_ami_id" {
  description = "app AMI ID"
  value       = aws_ami_from_instance.app_ami.id
}

output "app_launch_template_id" {
  description = "app Launch Template ID"
  value       = aws_launch_template.app.id
}

output "app_launch_template_latest_version" {
  value = aws_launch_template.app.latest_version
}
