# Import ALB and create autostopping rule
resource "harness_autostopping_aws_alb" "harness_alb" {
  name               = "${local.name}-lb"
  cloud_connector_id = var.harness_cloud_connector_id
  host_name          = local.lb_hostname
  alb_arn            = var.alb_arn == null ? aws_lb.alb[0].arn : var.alb_arn
  region             = var.region
  vpc                = var.vpc
  security_groups    = [aws_security_group.http.id]
  # setting hosted zone is not needed when route53 is already set up externally, ususally don't set this
  # route53_hosted_zone_id            = "/hostedzone/${var.hostedzone}"
  delete_cloud_resources_on_destroy = false
}

resource "harness_autostopping_rule_ecs" "rule" {
  name               = local.name
  cloud_connector_id = var.harness_cloud_connector_id
  idle_time_mins     = 5
  container {
    cluster    = aws_ecs_cluster.cluster.name
    service    = aws_ecs_service.service.name
    region     = var.region
    task_count = 1
  }
  http {
    proxy_id = harness_autostopping_aws_alb.harness_alb.identifier
  }
  custom_domains = [local.lb_hostname]
}