output "name" {
  value       = local.name
  description = "Name of the ec2 instance"
}

output "alb-url" {
  value       = "http://${aws_lb.alb[0].dns_name}"
  description = "URL of the ALB"
}

output "service" {
  value       = aws_ecs_service.service.id
  description = "ARN of the ECS service"
}

output "rule" {
  value       = "https://app.harness.io/ng/account/${data.harness_platform_current_account.current.id}/ce/autostopping-rules/rule/${harness_autostopping_rule_ecs.rule.id}"
  description = "Link to autostopping rule in Harness"
}

output "url" {
  value       = harness_autostopping_rule_ecs.rule.custom_domains[0]
  description = "URL for the application"
}