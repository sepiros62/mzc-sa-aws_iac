resource "aws_vpc" "this" {
    cidr_block  = var.vpc_cidr
 
    enable_dns_hostnames = true
    
    tags = merge(
        {
            Name = format("%s=prod-vpc", var.name)
        }
    )
}

resource "aws_subnet" "public" {
    count  = length(var.public_subnets)
    
    vpc_id = aws_vpc.this.id
    
    availability_zone = var.public_subnets[count.index].zone
    cidr_block = var.public_subnets[count.index].cidr
    
    # AUTO-ASIGN
    map_public_ip_on_launch = true
    
    tags = merge(
            {
                Name = format(
                    "%s-public-%s",
                    var.name,
                    element(split("", var.public_subnets[count.index].zone), length(var.public_subnets[count.index].zone) - 1)
            )
        },
        var.tags,
    )
}

resource "aws_subnet" "private" {
    count  = length(var.private_subnets)
    
    vpc_id = aws_vpc.this.id
    
    availability_zone = var.private_subnets[count.index].zone
    cidr_block = var.private_subnets[count.index].cidr
    
    # AUTO-ASIGN
    map_public_ip_on_launch = false
    
    tags = merge(
            {
                Name = format(
                    "%s-private-%s",
                    var.name,
                    element(split("", var.private_subnets[count.index].zone), length(var.private_subnets[count.index].zone) - 1)
            )
        },
        var.tags,
    )
}

resource "aws_route_table" "public" {
    #count  = length(var.private_subnet)
    
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
    tags = merge(
    {
        Name = format(
            "%s-public-rt",
            var.name,
        )
    },
        var.tags,
    )
}

resource "aws_route_table" "private" {
    #count  = length(var.private_subnets)
    
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.gw.id
    }

    tags = merge(
    {
        Name = format(
            "%s-private-rt",
            var.name,
        )
    },
        var.tags,
    )
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)
    
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets)
  #gateway_id     = aws_internet_gateway.private.id
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_eip" "lb" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_instance" "web" {
  ami           = "ami-01af223aa7f274198"
  instance_type = "t2.micro"
  key_name = "Megazone-Keypair"
  subnet_id = aws_subnet.public[1].id
  security_groups = [ aws_security_group.ssh.id ] 
}

resource "aws_security_group" "ssh" {
  name        = "SG-Web-Server"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
