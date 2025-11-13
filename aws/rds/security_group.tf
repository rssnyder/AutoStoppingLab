# Security group for the instance
resource "aws_security_group" "allow_mysql" {
  name        = "${local.name}-allow_mysql"
  description = "Allow MYSQL inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Open MYSQL"
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-allow_mysql"
  }
}

# Security group for the proxy
resource "aws_security_group" "allow_proxy" {
  name        = "${local.name}-allow_proxy"
  description = "Allow random inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Open port for ${local.name}"
    from_port   = random_integer.public_port.result
    to_port     = random_integer.public_port.result
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-allow_proxy"
  }
}