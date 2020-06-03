## Load VPC, Subnet Data ##
data "aws_vpc" "selected" {

 tags = {
   Name = "${var.name}-VPC"
 }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["ABC-Subnet-Public-0"]
  }
}


## Create Bastion Security-Group ##
resource "aws_security_group" "bastion" {
  name        = "${var.name}-SG-Bastion"
  description = "Bastion Server Security-Group (port 22)"

  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = var.allow_ip_address
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-SG-Bastion"
  }
}


## Create Bastion Host (EC2) ##
resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.public.id
  key_name      = var.key_name
  user_data     = var.user_data

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "${var.name}-Bastion-Server"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id

  vpc = true

  tags = {
    Name = "${var.name}-EIP-Bastion"
  }
}
