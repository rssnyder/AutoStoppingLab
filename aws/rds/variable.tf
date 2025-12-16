variable "name" {
  type        = string
  description = "A unique key to use for all resource. If not set a random name is generated"
  default     = null
}

variable "proxy_subnet" {
  type        = string
  description = "Subnet to place proxy in. Should be routable so you can access the application"
}

variable "rds_subnets" {
  type        = list(string)
  description = "Subnets to place RDS in"
}

variable "vpc" {
  type        = string
  description = "ID of existing VPC"
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region to deploy resources in"
}

variable "harness_cloud_connector_id" {
  type    = string
  default = "AWS CCM connector for target AWS account"
}

variable "harness_proxy_api_key" {
  type      = string
  default   = "pat.AM8HCbDiTXGQNrTIhNl7qQ.68bee55116344d7b8dad4ff7.Oni91Bw4TiGGjRXtwEeG"
  sensitive = true
}

variable "schedule_name" {
  type        = string
  description = "Name for the schedule"
  default     = "this"
}

variable "autostopping_schedules" {
  type = list(object({
    days       = list(string)
    start_time = string
    end_time   = string
  }))
  default     = null
  description = "Optional list of schedule repeat windows. If null, no Harness autostopping schedule will be created."
}

variable "schedule_time_zone" {
  type        = string
  description = "Timezone for uptime schedule"
  default     = "America/Chicago"
}
