resource "aws_iam_role" "ecs_task" {
  name = "${local.name}_ecs_task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# IAM role for EC2 container instances
resource "aws_iam_role" "ecs_instance" {
  name = "${local.name}_ecs_instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${local.name}_ecs_instance"
  role = aws_iam_role.ecs_instance.name
}

resource "aws_iam_role_policy" "ecs_task" {
  name = "${local.name}_ecs_task"
  role = aws_iam_role.ecs_task.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_ecs_cluster" "cluster" {
  name = local.name
}

# EC2 instance to run ECS tasks
resource "aws_instance" "ecs" {
  ami                    = var.ecs_ami
  instance_type          = var.instance_type
  subnet_id              = var.ec2_subnet
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance.name

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config
              EOF

  tags = {
    Name = "${local.name}-ecs-instance"
  }
}

resource "aws_ecs_task_definition" "task" {
  family = local.name
  container_definitions = jsonencode([
    {
      name      = local.name
      image     = "public.ecr.aws/docker/library/httpd:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      entryPoint = [
        "sh",
        "-c"
      ],
      command = [
        "/bin/sh -c \"echo '<html> <head> <title>ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>You are all set to AutoStop</h2> <p>This application is running on a container in Amazon ECS.</p> </div></body></html>' > /usr/local/apache2/htdocs/index.html && httpd-foreground\""
      ],
    }
  ])
  execution_role_arn       = aws_iam_role.ecs_task.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
}

resource "aws_ecs_service" "service" {
  name            = local.name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.http.arn
    container_name   = local.name
    container_port   = 80
  }

  depends_on = [aws_instance.ecs]
}