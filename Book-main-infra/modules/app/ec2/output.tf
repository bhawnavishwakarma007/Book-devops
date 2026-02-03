output "app_instance_id" {
  value = aws_instance.app_server.id
}

output "app_private_ip" {
  value = aws_instance.app_server.private_ip
}
