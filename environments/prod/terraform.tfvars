aws_region         = "ap-southeast-2"
environment        = "prod"
business_division  = "lab"

vpc_name           = "lab01-prod"
vpc_cidr_block     = "10.20.0.0/16"    

public_subnet_cidr_block   = ["10.20.1.0/24","10.20.2.0/24","10.20.3.0/24"]
private_subnet_cidr_block  = ["10.20.100.0/24","10.20.101.0/24","10.20.102.0/24"]
database_subnet_cidr_block = ["10.20.150.0/24","10.20.151.0/24","10.20.152.0/24"]

instance_type = "t3.small"   
key_name      = "ec2-instances-prod"

db_name = "qmsapp"