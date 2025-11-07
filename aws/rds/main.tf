locals {
  name    = var.name == null ? random_pet.name.id : lower(var.name)
  db_port = 5432
}

data "harness_platform_current_account" "current" {}

resource "random_pet" "name" {
  keepers = {
    name = var.name
  }
}

resource "random_integer" "public_port" {
  min = 1024
  max = 65535
  keepers = {
    name = local.name
  }
}