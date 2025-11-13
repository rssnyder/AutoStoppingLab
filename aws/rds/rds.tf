resource "aws_db_subnet_group" "rds" {
  name       = local.name
  subnet_ids = var.rds_subnets

  tags = {
    Name = local.name
  }
}

data "aws_rds_engine_version" "postgres" {
  engine = "postgres"
  latest = true
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_name                = replace(local.name, "-", "")
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  engine                 = "postgres"
  engine_version         = data.aws_rds_engine_version.postgres.version
  instance_class         = "db.t4g.micro"
  username               = "harnessdb"
  password               = "harnessdb"
  parameter_group_name   = "default.postgres${split(".", data.aws_rds_engine_version.postgres.version)[0]}"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}