# AWS Lambda Route 53 Auto CNAME



## Terraform version
Module compatible with Terraform `0.12`


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app\_name | Application Name | string | `"route53_autoalias"` | no |
| log\_retention\_days | Cloudwatch Log Retation Days | number | `"14"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_event\_rule\_id | Cloudwatch rule ID |
| lambda\_arn | AWS Lambda ARN |
| lambda\_iam\_role\_arn | IAM role ARN |
| lambda\_iam\_role\_name | IAM role name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


