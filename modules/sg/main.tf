resource "aws_security_group" "ec2_public_sg" {
  name        = "ec2_public_sg"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    description = "Allow remote ssh from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.name}-ec2-public-sg"
  }
}

resource "aws_security_group" "ec2_private_sg" {
  name        = "ec2_private_sg"
  description = "Allow App-Port inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [var.cidr_blocks]
    protocol = "tcp"
    description = "Allow remote ssh within vpc"
  }

  ingress {
    from_port = 8000
    to_port = 8000
    cidr_blocks = [var.cidr_blocks]
    protocol = "tcp"
    description = "Allow port for java app"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }
  tags = {
    Name = "${var.name}-ec2-private-sg"
  }
}

resource "aws_security_group" "rds_mysql_sg" {
  name        = "rds_mysql_sg"
  description = "Allow access to RDS from EC2 present in public subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    cidr_blocks = [var.cidr_blocks]
    protocol = "tcp"
    description = "Allow port for mysql"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.name}-rds-mysql-sg"
  }
}

resource "aws_security_group" "loadbalancer_sg" {
  name = "loadbalancer_sg"
  description = "Allow HTTP inbound for the internet"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    description = "Allow port for http"
  }

  ingress {
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    description = "Allow port for https"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }


  tags = {
    Name = "${var.name}-rds-mysql-sg"
  }
}