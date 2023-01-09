output "instance_id" {
  value = aws_instance.main.id
}

output "instance_internal_ip" {
  value = aws_instance.main.private_ip
}

output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "instance" {
  value = aws_instance.main
}
