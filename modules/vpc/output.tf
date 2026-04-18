output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "cidr_block" {
  value = aws_vpc.my_vpc.cidr_block
}

output "public_subnet_ids" {
    value = [for s in aws_subnet.public_subnet: s.id]
}

output "private_subnet_ids" {
    value = [for s in aws_subnet.private_subnet: s.id]
}

output "database_subnet_ids" {
    value = [for s in aws_subnet.database_subnet: s.id]
}

output "public_subnet" {
    value = {
        for subnet in values(aws_subnet.public_subnet):
        subnet.id => subnet.cidr_block
    }
}
output "private_subnet" {
    value = {
        for subnet in values(aws_subnet.private_subnet):
        subnet.id => subnet.cidr_block
    }
}

output "nat_public_ip" {
    value = aws_eip.nat_eip.public_ip
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}