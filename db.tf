locals {
  db_type              = "db.t3.micro"
  db_engine            = "mysql"
  db_storage_size      = 20
  db_username          = "admin"
  db_subnet_group_name = "default-vpc-0a62e20d7071f05a1"
  db_public_accessible = true
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
  availability_zone      = "${data.aws_region.current.name}c"
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

// DocumentDB
resource "aws_security_group" "docdb" {
  name        = "docdb_security_group"
  description = "Security group for DocumentDB"
  vpc_id      =  module.vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "xquare-docdb-cluster"
  engine                  = "docdb"
  master_username         = "xquare"
  master_password         = var.docdb_master_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true

  vpc_security_group_ids = [aws_security_group.docdb.id]
  db_subnet_group_name   = aws_docdb_subnet_group.docdb.name
}

resource "aws_docdb_subnet_group" "docdb" {
  name       = "xquare-docdb-subnet-group"
  subnet_ids = module.vpc.public_subnet_ids
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "xquare-docdb-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.r6g.large"
}
