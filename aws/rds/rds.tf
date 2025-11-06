resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_name                = local.name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = "harnessdb"
  password               = "harnessdb"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.allow_mysql.id]
}