locals {
  db_type              = "db.t3.micro"
  db_engine            = "mysql"
  db_storage_size      = 20
  db_username          = "admin"
  db_subnet_group_name = "xquare_db_subnet_group"
  db_public_accessible = true

  az_subnets = [
        for id, subnet in data.aws_subnet.this :
        id
        if subnet.availability_zone == "${local.region}a"
  ]
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
}

data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}

resource "aws_db_subnet_group" "xquare_db_subnet_group" {
  name       = local.db_subnet_group_name
  subnet_ids = local.az_subnets

  tags = {
    Name = local.db_subnet_group_name
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Security group for rds on port 3306"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "xquare-db" {
  identifier             = "${local.name_prefix}-db"
  allocated_storage      = local.db_storage_size
  engine                 = local.db_engine
  instance_class         = local.db_type
  availability_zone      = "${data.aws_region.current.name}a"
  username               = local.db_username
  password               = var.rds_master_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = local.db_subnet_group_name
  publicly_accessible    = local.db_public_accessible
  parameter_group_name   = aws_db_parameter_group.xquare-pg.name
}

resource "aws_db_parameter_group" "xquare-pg" {
  name   = "rds-max-connection"
  family = "mysql8.0"

  parameter {
    name  = "max_connections"
    value = "100000"
  }
}