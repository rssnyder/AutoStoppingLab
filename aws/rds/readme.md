# AWS - RDS

Provision an rds, proxy, and create an autostopping rule for the instance.

<img width="2091" height="1334" alt="image" src="https://github.com/user-attachments/assets/8d6caff8-75ed-4d4a-9774-1141c414c788" />

## Setup

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your inputs
2. [Configure AWS authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for Terraform
3. [Configure Harness authentication](https://registry.terraform.io/providers/harness/harness/latest/docs) for Terraform
    a. `HARNESS_ACCOUNT_ID`: your Harness account id
    b. `HARNESS_PLATFORM_API_KEY`: an api key for your Harness account, with access to create autostopping rules with the specific ccm aws connector
4. Create the resources with `tofu aply`
    a. You can create the resources in two parts to test the application before and after harness integration.
    b. Run OpenTofu to create the AWS resources using the `-exclude` flag to exclude the Harness resources `tofu apply -exclude=harness_autostopping_aws_proxy.harness_proxy -exclude=harness_autostopping_rule_rds.rule`
    b. Validate the alb is working by accessing the url in your browser
    c. Import the ALB into harness and create the autostopping rule by running a full `tofu apply`

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| harness | 0.37.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 5.100.0 |
| harness | 0.37.1 |
| random | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.allow_mysql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [harness_autostopping_aws_proxy.harness_proxy](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/resources/autostopping_aws_proxy) | resource |
| [harness_autostopping_rule_rds.rule](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/resources/autostopping_rule_rds) | resource |
| [random_integer.public_port](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_rds_engine_version.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| harness\_cloud\_connector\_id | n/a | `string` | `"AWS CCM connector for target AWS account"` | no |
| harness\_proxy\_api\_key | n/a | `string` | `"pat.AM8HCbDiTXGQNrTIhNl7qQ.68bee55116344d7b8dad4ff7.Oni91Bw4TiGGjRXtwEeG"` | no |
| name | A unique key to use for all resource. If not set a random name is generated | `string` | `null` | no |
| proxy\_subnet | Subnet to place proxy in. Should be routable so you can access the application | `string` | n/a | yes |
| rds\_subnets | Subnets to place RDS in | `list(string)` | n/a | yes |
| region | AWS region to deploy resources in | `string` | `"us-west-2"` | no |
| vpc | ID of existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db-address | Address of the rds instance |
| db-name | Name of the database |
| direct-connection | Direct connection string for the database |
| name | Name of the rds instance |
| proxy-connection | Proxy connection string for the database |
| rule | Link to autostopping rule in Harness |