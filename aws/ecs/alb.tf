# configure a security group for our ALB that whitelists ports required for http
resource "aws_security_group" "http" {
  name        = "${local.name}-alb"
  description = "Security group for whitelisting ports required for http"
  vpc_id      = var.vpc

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-alb"
  }
}

# provision an ALB that routes traffic to our instance
resource "aws_lb" "alb" {
  count              = var.alb_arn == null ? 1 : 0
  name               = "${local.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http.id]
  subnets            = var.alb_subnets
}

# configure a listener for our ALB that accepts traffic on port 80 and forwards it to our target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = var.alb_arn == null ? aws_lb.alb[0].arn : var.alb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

# configure a listener rule for our ALB that forwards traffic to our target group
resource "aws_lb_listener_rule" "target" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }

  condition {
    host_header {
      values = [local.lb_hostname]
    }
  }
}

# configure a target group for our ALB that forwards traffic to our EC2 on port 80
resource "aws_lb_target_group" "http" {
  name        = "${local.name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc
}
