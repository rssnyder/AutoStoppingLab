# AWS - EC2

Provision an EC2 instance, alb, and create an autostopping rule for the instance.

![image](https://github.com/wings-software/AutoStoppingLab/assets/7338312/7ede2ec4-45a3-43ff-95d6-60abbaaea64d)

## Setup

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your inputs
2. [Configure AWS authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for Terraform
3. [Configure Harness authentication](https://registry.terraform.io/providers/harness/harness/latest/docs) for Terraform
    a. `HARNESS_ACCOUNT_ID`: your Harness account id
    b. `HARNESS_PLATFORM_API_KEY`: an api key for your Harness account, with CCM admin permissions
4. Run OpenTofu to create the AWS resources using the `-exclude` flag to exclude the Harness resources
    a. Provision an alb, listener, and target group for the ec2 machine with nginx insalled `tofu apply -exclude=harness_autostopping_aws_alb.harness_alb -exclude=harness_autostopping_rule_vm.rule`
    b. Validate the alb is working by accessing the url in your browser
    c. Import the ALB into harness and create the autostopping rule by running a full `tofu apply`

![image](https://github.com/wings-software/AutoStoppingLab/assets/7338312/ab1a3163-3657-4244-833b-7e8ccb4b176b)

## Requirements

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| harness | 0.37.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 5.94.1 |
| harness | 0.37.1 |
| random | 3.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.static](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.allow_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [harness_autostopping_aws_alb.harness_alb](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/resources/autostopping_aws_alb) | resource |
| [harness_autostopping_rule_vm.rule](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/resources/autostopping_rule_vm) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/0.37.1/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | An existing ALB arn to use. If not set one will be created for you | `string` | `null` | no |
| alb\_subnets | Subnet to place ALB in. Should be routable so you can access the application | `list(string)` | n/a | yes |
| ami | Ubuntu ami (default is for us-west-2) | `string` | `"ami-0efcece6bed30fd98"` | no |
| ec2\_subnet | Subnet to place EC2 in | `string` | n/a | yes |
| harness\_cloud\_connector\_id | n/a | `string` | `"AWS CCM connector for target AWS account"` | no |
| hostedzone | Hosted zone id to use for application routing. If not set will use default ALB url | `string` | `null` | no |
| name | A unique key to use for all resource. If not set a random name is generated | `string` | `null` | no |
| region | AWS region to deploy resources in | `string` | `"us-west-2"` | no |
| vpc | ID of existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ec2 | ARN of the ec2 instance |
| name | Name of the ec2 instance |
| rule | Link to autostopping rule in Harness |
| url | URL for the application |
