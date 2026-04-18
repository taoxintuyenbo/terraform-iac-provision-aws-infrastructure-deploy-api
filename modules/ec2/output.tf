output "ec2_public_instance" {
  value = aws_instance.ec2_public
}
output "ec2_private_instances" {
  value = aws_instance.ec2_private
}

output "ec2_public_instance_public_ip" {
  value = aws_instance.ec2_public.public_ip
}