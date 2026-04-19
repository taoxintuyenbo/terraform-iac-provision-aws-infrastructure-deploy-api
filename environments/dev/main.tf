module "vpc" {
    source = "../../modules/vpc"
    vpc_name = var.vpc_name
    vpc_cidr_block = var.vpc_cidr_block
    public_subnet_cidr_block = var.public_subnet_cidr_block
    private_subnet_cidr_block = var.private_subnet_cidr_block
    database_subnet_cidr_block = var.database_subnet_cidr_block
    name = local.name
    tags = local.common_tags
}

module "sg" {
    source = "../../modules/sg"
    vpc_id = module.vpc.vpc_id
    cidr_blocks = module.vpc.cidr_block
    name = local.name
}

module "ec2"{
    depends_on = [module.vpc]
    source = "../../modules/ec2"
    instance_type = var.instance_type
    key_name = var.key_name
    public_subnets = module.vpc.public_subnet_ids
    private_subnets = module.vpc.private_subnet_ids
    ec2_public_sg_id = module.sg.ec2_public_sg_id
    ec2_private_sg_id = module.sg.ec2_private_sg_id
    instance_profile_name= module.iam.instance_profile_name
    user_data = templatefile("${path.module}/../../app-install.sh",{
        aws_region = var.aws_region
        db_name = var.db_name
        secret_arn = module.rds.db_master_secret_arn
        db_host   = module.rds.db_endpoint
    })
    
    name = local.name
    tags = local.common_tags
}

module "lb_target_group"{
    source = "../../modules/tg"
    lb_tg_name = "target-group-${var.environment}"
    lb_tg_port = 8000
    lb_tg_protocol = "HTTP"
    vpc_id = module.vpc.vpc_id
    ec2_private_instances = module.ec2.ec2_private_instances
}

module "alb"{
    source = "../../modules/alb"
    lb_sg = module.sg.loadbalancer_sg
    public_subnets = module.vpc.public_subnet_ids
    acm_certificate = module.acm.acm_certificate_arn
    ec2_ltg = module.lb_target_group.ec2_ltg_arn

   name = local.name
   tags = local.common_tags
}

module "route53" {
    source = "../../modules/route53"
    alb_dns_name = module.alb.alb_dns_name
    alb_zone_id = module.alb.alb_zone_id
}

module "acm" {
    source = "../../modules/acm"
    mydomain = module.route53.mydomain_name
    domain_zoneid = module.route53.mydomain_zoneid
    
    tags = local.common_tags
}

module "rds" {
    source = "../../modules/rds"
    db_instance_class = "db.t3.micro"
    database_subnet = module.vpc.database_subnet_ids
    rds_mysql_sg_id = module.sg.rds_mysql_sg_id
    dbname = var.db_name
    username = "admin"

    name = local.name
}

module "iam" {
    source = "../../modules/iam"
    name = local.name
    db_master_secret_arn = module.rds.db_master_secret_arn
}
