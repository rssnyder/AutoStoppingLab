output "name" {
  value       = local.name
  description = "Name of the ec2 instance"
}

output "alb-url" {
  value       = "http://${aws_lb.alb[0].dns_name}"
  description = "URL of the ALB"
}

output "ec2" {
  value       = aws_instance.ec2.arn
  description = "ARN of the ec2 instance"
}

output "rule" {
  value       = "https://app.harness.io/ng/account/${data.harness_platform_current_account.current.id}/ce/autostopping-rules/rule/${harness_autostopping_rule_vm.rule.id}"
  description = "Link to autostopping rule in Harness"
}

output "url" {
  value       = "http://${harness_autostopping_rule_vm.rule.custom_domains[0]}"
  description = "URL for the application"
}