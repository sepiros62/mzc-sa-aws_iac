resource "aws_vpc" "this" {
  cidr_block  = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-VPC", var.name)
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-IGW", var.name)
    }
}

resource "aws_route_table" "public" {
  count  = 2

  vpc_id = aws_vpc.this.id

  tags = {
      Name = format("%s-RT-Public-%s", var.name, count.index)
  }
}

resource "aws_route" "public" {
  count = 2 # length(var.public_subnets)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "public" {
    count  = length(var.public_subnets)

    vpc_id = aws_vpc.this.id

    availability_zone = var.public_subnets[count.index].zone

    cidr_block = var.public_subnets[count.index].cidr

    map_public_ip_on_launch = true

    tags = {
      Name = format("%s-Subnet-Public-%s", var.name, count.index)
    }
}

resource "aws_route_table_association" "public" {
  count = 2 #length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_eip" "private" {
  vpc      = true

  depends_on = [aws_route_table.public]

  tags = {
    Name = format("%s-private", var.name)
  }
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.private.id

  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = format("%s-NGW", var.name)
  }
}

resource "aws_route_table" "private" {
    count  = 2
    vpc_id = aws_vpc.this.id

    lifecycle {
      ignore_changes = [propagating_vgws]
    }

    tags = {
        Name = format("%s-RT-Private-%s", var.name, count.index)
    }
}

resource "aws_route" "private" {
  count = 2 #length(var.private_subnets)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private.id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "private" {
    count  = length(var.private_subnets)

    vpc_id = aws_vpc.this.id

    availability_zone = var.private_subnets[count.index].zone

    cidr_block = var.private_subnets[count.index].cidr

    map_public_ip_on_launch = false

    tags = {
      Name = format("%s-Subnet-private-%s", var.name, count.index)
    }
}

resource "aws_route_table_association" "private" {
  count = 2 #length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

