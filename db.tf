locals {
  db_type              = "db.t3.micro"
  db_engine            = "mysql"
  db_storage_size      = 20
  db_username          = "admin"
  db_security_group_id = "sg-0a33caeeab6bd2153"
  db_subnet_group_name = "default-vpc-00dba85fbdc1b606e"
  db_public_accessible = true
}

resource "aws_db_instance" "xquare-db" {
  identifier             = "${local.name_prefix}-db"
  allocated_storage      = local.db_storage_size
  engine                 = local.db_engine
  instance_class         = local.db_type
  availability_zone      = "${data.aws_region.current.name}c"
  username               = local.db_username
  password               = var.rds_master_password
  vpc_security_group_ids = [local.db_security_group_id]
  db_subnet_group_name   = local.db_subnet_group_name
  publicly_accessible    = local.db_public_accessible
}
