## Load VPC, Subnet, Security Group Data ##
data "aws_vpc" "selected" {

   tags = {
     Name = "${var.name}-VPC"
   }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Tier"
    values = ["DB-Subnet-Private"]
  }
}


## Create Aurora Cluster Subnet-Group ##
resource "aws_db_subnet_group" "aurora" {
  name        = "abc-aurora-subnet"
  description = "Aurora Database Cluster Sebnet-Group"
  subnet_ids  = data.aws_subnet_ids.private.ids

  tags = {
    Name = "ABC-DB-Subnet-Group"
  }
}


## Create Aurora Cluster Parameter-Group ##
resource "aws_rds_cluster_parameter_group" "default" {
  name        = "abc-aurora-cluster-mysql56"
  description = "Aurora Database Cluster Parameter-Group (v5.6)"
  family      = "aurora5.6"
}


## Create Aurora Security-Group ##
resource "aws_security_group" "aurora" {
  name        = "${var.name}-SG-Aurora"
  description = "Aurora Database Security-Group (port 3306)"

  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port = "3306"
    to_port   = "3306"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name ="${var.name}-SG-Aurora"
  }
}


## Create Aurora Cluster Instance ##
resource "aws_rds_cluster_instance" "cluster_instance" {
  count	                  = 2
  identifier              = "abc-aurora-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.default.id
  engine                  = "aurora"
  engine_version          = "5.6.10a"
  instance_class          = "db.t2.small"
  auto_minor_version_upgrade = false
  performance_insights_enabled = false
  db_subnet_group_name    = aws_db_subnet_group.aurora.name

  lifecycle {
      create_before_destroy = true
  }

  tags = {
    Name = "ABC-Aurora-Instance-${count.index}"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "abc-aurora-cluster"
  database_name           = "abcdb"
  master_username         = "admin"
  master_password         = "cdnadmin"

  vpc_security_group_ids  = [aws_security_group.aurora.id]
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.default.name

  deletion_protection     = false

  lifecycle {
      create_before_destroy = true
  }

  tags = {
    Name = "ABC-Aurora-Cluster"
  }
}
