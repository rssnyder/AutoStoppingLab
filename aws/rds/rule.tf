# Create a proxy vm with a public IP
resource "harness_autostopping_aws_proxy" "harness_proxy" {
  name                              = local.name
  cloud_connector_id                = var.harness_cloud_connector_id
  host_name                         = "192.168.0.1.nip.io"
  region                            = var.region
  vpc                               = var.vpc
  security_groups                   = [aws_security_group.allow_proxy.id]
  machine_type                      = "t3.micro"
  api_key                           = var.harness_proxy_api_key
  allocate_static_ip                = true
  delete_cloud_resources_on_destroy = true
}

resource "harness_autostopping_rule_rds" "rule" {
  name               = local.name
  cloud_connector_id = var.harness_cloud_connector_id
  idle_time_mins     = 5
  database {
    id     = aws_db_instance.rds.arn
    region = var.region
  }
  tcp {
    proxy_id = harness_autostopping_aws_proxy.harness_proxy.id
    forward_rule {
      connect_on = random_integer.public_port.result
      port       = local.db_port
    }
  }
}

resource "harness_autostopping_schedule" "this" {
  count         = var.autostopping_schedules == null || length(var.autostopping_schedules) == 0 ? 0 : 1
  name          = var.schedule_name
  schedule_type = "uptime"
  time_zone     = var.schedule_time_zone

  dynamic "repeats" {
    for_each = var.autostopping_schedules == null ? [] : var.autostopping_schedules
    content {
      days       = repeats.value.days
      start_time = repeats.value.start_time
      end_time   = repeats.value.end_time
    }
  }

  rules = [harness_autostopping_rule_rds.rule.id]
}