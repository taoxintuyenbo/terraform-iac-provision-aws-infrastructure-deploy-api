aws_region = "ap-southeast-2"
environment = "dev"
business_division = "lab"

vpc_name = "lab01-dev"
vpc_cidr_block = "10.10.0.0/16"
public_subnet_cidr_block = ["10.10.1.0/24","10.10.2.0/24","10.10.3.0/24"]
private_subnet_cidr_block = ["10.10.100.0/24","10.10.101.0/24","10.10.102.0/24"]
database_subnet_cidr_block = ["10.10.150.0/24","10.10.151.0/24","10.10.152.0/24"]

instance_type = "t3.micro"
key_name = "ec2-instances"

db_name = "qmsapp-dev"