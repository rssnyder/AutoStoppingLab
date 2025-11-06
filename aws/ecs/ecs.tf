resource "aws_ecs_cluster" "cluster" {
  name = local.name
}

resource "aws_ecs_task_definition" "task" {
  family = local.name
  container_definitions = jsonencode([
    {
      name      = local.name
      image     = "public.ecr.aws/docker/library/httpd:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          name          = "http-tcp"
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
  execution_role_arn       = var.task_exec_role
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

}

resource "aws_ecs_service" "service" {
  name             = local.name
  cluster          = aws_ecs_cluster.cluster.id
  task_definition  = aws_ecs_task_definition.service.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.allow_http.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.http.arn
    container_name   = local.name
    container_port   = 80
  }
}