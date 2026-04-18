resource "aws_instance" "ec2_public" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name = var.key_name

  subnet_id = var.public_subnets[0]
  vpc_security_group_ids = [var.ec2_public_sg_id]

  tags = merge(
    { Name = "${var.name}-ec2-public" },
    var.tags 
  )
}


resource "aws_instance" "ec2_private" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  key_name = var.key_name

  for_each = {
    for idx, subnet in var.private_subnets:
    idx => subnet
  }
  subnet_id = each.value
  vpc_security_group_ids = [var.ec2_private_sg_id]
  iam_instance_profile = var.instance_profile_name
  user_data = var.user_data

  tags = merge(
    { Name = "${var.name}-ec2-private-${each.key+1}" },
    var.tags 
  )
}