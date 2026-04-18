output "ec2_public_sg_id" {
    value = aws_security_group.ec2_public_sg.id
}

output "ec2_private_sg_id" {
    value = aws_security_group.ec2_private_sg.id
}

output "rds_mysql_sg_id" {
    value = aws_security_group.rds_mysql_sg.id
}

output "loadbalancer_sg" {
    value = aws_security_group.loadbalancer_sg.id
}


