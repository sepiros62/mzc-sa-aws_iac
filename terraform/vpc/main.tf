## Create Virtual Private Cloud ##
resource "aws_vpc" "selected" {
  cidr_block  = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-VPC", var.name)
    }
}


## Create Internet Gateway ##
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.selected.id

  tags = {
    Name = format("%s-IGW", var.name)
    }
}


## Create Public Routeing Tables ##
resource "aws_route_table" "public" {
  count  = 1

  vpc_id = aws_vpc.selected.id

  tags = {
      Name = format("%s-RT-Public-%s", var.name, count.index)
      Tier = format("%s-RT-Public", var.name)
  }
}

resource "aws_route" "public" {
  count = 1

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

  timeouts {
    create = "5m"
  }
}


## Create Public Subnet ##
resource "aws_subnet" "public" {
    count  = length(var.public_subnets)

    vpc_id = aws_vpc.selected.id

    availability_zone = var.public_subnets[count.index].zone

    cidr_block = var.public_subnets[count.index].cidr

    map_public_ip_on_launch = true

    tags = {
      Name = format("%s-Subnet-Public-%s", var.name, count.index)
      Tier = format("%s", var.public_subnets[count.index].tier)
    }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}


## Create Private Routeing Tables ##
resource "aws_route_table" "private" {
    count  = 2

    vpc_id = aws_vpc.selected.id

    lifecycle {
      ignore_changes = [propagating_vgws]
    }

    tags = {
      Name = format("%s-RT-Private-%s", var.name, count.index)
      Tier = format("%s-RT-Private", var.name)
    }
}


## Create NAT Gateway ##
resource "aws_eip" "private" {
  count    = 2
  vpc      = true

  depends_on = [aws_route_table.public]

  tags = {
    Name = format("%s-EIP-Private-%s", var.name, count.index)
  }
}

resource "aws_nat_gateway" "private" {
  count = 2

  allocation_id = aws_eip.private[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("%s-NAT-GW-%s", var.name, count.index)
  }
}


## Create Private Subnet ##
resource "aws_route" "private" {
  count = 2

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private[count.index].id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "private" {
    count  = length(var.private_subnets)

    vpc_id = aws_vpc.selected.id

    availability_zone = var.private_subnets[count.index].zone

    cidr_block = var.private_subnets[count.index].cidr

    map_public_ip_on_launch = false

    tags = {
      Name = format("%s-Subnet-private-%s", var.name, count.index)
      Tier = format("%s", var.private_subnets[count.index].tier)
    }
}

# resource "aws_route_table_association" "private" {
#   count = length(var.private_subnets)

#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[0].id
# }
