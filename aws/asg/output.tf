output "name" {
  value       = local.name
  description = "Name of the asg"
}

output "asg" {
  value       = aws_autoscaling_group.asg.arn
  description = "ARN of the asg"
}

output "rule" {
  value       = "https://app.harness.io/ng/account/${data.harness_platform_current_account.current.id}/ce/autostopping-rules/rule/${harness_autostopping_rule_scale_group.rule.id}"
  description = "Link to autostopping rule in Harness"
}

output "url" {
  value       = harness_autostopping_rule_scale_group.rule.custom_domains[0]
  description = "URL for the application"
}