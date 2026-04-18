resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = merge(
        {Name = "${var.name}-${var.vpc_name}"},
        var.tags
    )
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    for_each = toset(data.aws_availability_zones.available.names)
    cidr_block = var.public_subnet_cidr_block[index(data.aws_availability_zones.available.names,each.value)]
    availability_zone = each.value
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.name}-${each.key}-public-subnet"
    }

}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    for_each = toset(data.aws_availability_zones.available.names)
    cidr_block = var.private_subnet_cidr_block[index(data.aws_availability_zones.available.names,each.value)]
    availability_zone = each.value

    tags = {
        Name = "${var.name}-${each.key}-private-subnet"
    }
}

resource "aws_subnet" "database_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    for_each = toset(data.aws_availability_zones.available.names)
    cidr_block = var.database_subnet_cidr_block[index(data.aws_availability_zones.available.names,each.value)]
    availability_zone = each.value

    tags = {
        Name = "${var.name}-${each.key}-database-subnet"
    }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = values(aws_subnet.public_subnet)[0].id

  tags = {
    Name = "${var.name}-nat-gw"
  }
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name}-public-rtb"
  }
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.name}-private-rtb"
  }
 depends_on = [aws_nat_gateway.nat_gw]
}

resource "aws_route_table" "database_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-database-rtb"
  }
}

resource "aws_route_table_association" "public_rtb_subnet_association" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "private_rtb_subnet_association" {
  for_each = aws_subnet.private_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "database_rtb_subnet_association" {
  for_each = aws_subnet.database_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.database_rtb.id
}