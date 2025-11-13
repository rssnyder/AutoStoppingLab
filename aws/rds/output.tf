output "name" {
  value       = local.name
  description = "Name of the rds instance"
}

# output "proxy" {
#   value       = aws_lb.proxy.id
#   description = "ARN of the proxy"
# }

output "db-address" {
  value       = aws_db_instance.rds.address
  description = "Address of the rds instance"
}

output "db-name" {
  value       = aws_db_instance.rds.db_name
  description = "Name of the database"
}

output "direct-connection" {
  value       = "psql -h ${aws_db_instance.rds.address} -U harnessdb ${aws_db_instance.rds.db_name}"
  description = "Direct connection string for the database"
}

output "rule" {
  value       = "https://app.harness.io/ng/account/${data.harness_platform_current_account.current.id}/ce/autostopping-rules/rule/${harness_autostopping_rule_rds.rule.id}"
  description = "Link to autostopping rule in Harness"
}

output "proxy-connection" {
  value       = "psql -h <address of proxy> -p ${random_integer.public_port.result} -U harnessdb ${aws_db_instance.rds.db_name}"
  description = "Proxy connection string for the database"
}