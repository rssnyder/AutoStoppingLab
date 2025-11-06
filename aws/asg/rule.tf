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

# resource "harness_autostopping_rule_vm" "rule" {
#   name               = "${local.name}-ec2-rule"
#   cloud_connector_id = var.harness_cloud_connector_id
#   idle_time_mins     = 5
#   filter {
#     vm_ids  = [aws_instance.ec2.id]
#     regions = [var.region]
#   }
#   http {
#     proxy_id = harness_autostopping_aws_alb.harness_alb.identifier
#     routing {
#       # these are how traffic comes into the alb
#       source_protocol = lower(aws_lb_target_group.http.protocol)
#       source_port     = aws_lb_target_group.http.port
#       # these are how traffic goes out of the alb to the ec2
#       target_protocol = lower(aws_lb_target_group.http.protocol)
#       target_port     = aws_lb_target_group_attachment.ec2.port
#       action          = "forward"
#     }
#     # this should be configured to match the target group health check
#     health {
#       protocol         = lower(aws_lb_target_group.http.protocol)
#       port             = aws_lb_target_group_attachment.ec2.port
#       path             = "/"
#       timeout          = 30
#       status_code_from = 200
#       status_code_to   = 299
#     }
#   }
#   custom_domains = [local.lb_hostname]
# }