## DIA Terraform Module for creating and distributing SSH Key pairs on AWS
---------------------------------------------------------------------

Terraform module for creating ssh key pairs locally, encrypting them and uploading them to S3.

##### Requirements
-------------------------------

This module requires Terraform 0.8+


##### Module Input Variables
--------------------------------
- `team` - The team creating the keys.
- `project` - The project for which the keys are created.
- `region` - The AWS region e.g. (eu-west-1 or eu-central-1)
- `environment` - The deployment environment in which this EFS is needed (qa, staging, production)
- `secrets_bucket_kms_key_arn` - The ARN of a KMS key used for encrypting the SSH keys.
- `secrets_bucket_name` - The name of the S3 bucket where the keys should be stored.


##### Module Outputs
-------------------------------


##### Usage
-------------------------------

```bash
```