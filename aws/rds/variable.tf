variable "name" {
  type        = string
  description = "A unique key to use for all resource. If not set a random name is generated"
  default     = null
}

variable "proxy_subnet" {
  type        = list(string)
  description = "Subnet to place proxy in. Should be routable so you can access the application"
}

variable "rds_subnet" {
  type        = string
  description = "Subnet to place RDS in"
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
