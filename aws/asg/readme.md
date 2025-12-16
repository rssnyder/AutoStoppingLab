# AWS - ASG

Provision an asg, alb, and create an autostopping rule for the scaling group.

Optionally create a schedule.

<img width="2091" height="1334" alt="image" src="https://github.com/user-attachments/assets/8d6caff8-75ed-4d4a-9774-1141c414c788" />

## Setup

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your inputs
2. [Configure AWS authentication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) for Terraform
3. [Configure Harness authentication](https://registry.terraform.io/providers/harness/harness/latest/docs) for Terraform
    a. `HARNESS_ACCOUNT_ID`: your Harness account id
    b. `HARNESS_PLATFORM_API_KEY`: an api key for your Harness account, with access to create autostopping rules with the specific ccm aws connector
4. Create the resources with `tofu aply`
    a. You can create the resources in two parts to test the application before and after harness integration.
    b. Run OpenTofu to create the AWS resources using the `-exclude` flag to exclude the Harness resources `tofu apply -exclude=harness_autostopping_aws_alb.harness_alb -exclude=harness_autostopping_rule_vm.rule`
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
| aws | 5.94.1 |
| harness | 0.37.1 |
| random | 3.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_template.template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.allow_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [harness_autostopping_aws_alb.harness_alb](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/autostopping_aws_alb) | resource |
| [harness_autostopping_rule_scale_group.rule](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/autostopping_rule_scale_group) | resource |
| [harness_autostopping_schedule.this](https://registry.terraform.io/providers/harness/harness/latest/docs/resources/autostopping_schedule) | resource |
| [random_pet.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet.asg_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [harness_platform_current_account.current](https://registry.terraform.io/providers/harness/harness/latest/docs/data-sources/platform_current_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | An existing ALB arn to use. If not set one will be created for you | `string` | `null` | no |
| alb\_subnets | Subnet to place ALB in. Should be routable so you can access the application | `list(string)` | n/a | yes |
| ami | Ubuntu ami (default is for us-west-2) | `string` | `"ami-0efcece6bed30fd98"` | no |
| asg\_subnet | Subnet to place ASG in | `string` | n/a | yes |
| autostopping\_schedules | Optional list of schedule repeat windows. If null, no Harness autostopping schedule will be created. | <pre>list(object({<br/>    days       = list(string)<br/>    start_time = string<br/>    end_time   = string<br/>  }))</pre> | `null` | no |
| harness\_cloud\_connector\_id | n/a | `string` | `"AWS CCM connector for target AWS account"` | no |
| hostedzone | Hosted zone id to use for application routing. If not set will use default ALB url | `string` | `null` | no |
| name | A unique key to use for all resource. If not set a random name is generated | `string` | `null` | no |
| region | AWS region to deploy resources in | `string` | `"us-west-2"` | no |
| schedule\_name | Name for the schedule | `string` | `"this"` | no |
| schedule\_time\_zone | Timezone for uptime schedule | `string` | `"America/Chicago"` | no |
| vpc | ID of existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ec2 | ARN of the ec2 instance |
| name | Name of the ec2 instance |
| rule | Link to autostopping rule in Harness |
| url | URL for the application |
