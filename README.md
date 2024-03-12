# Terraform AWS Repository

This repository contains Terraform configuration files for provisioning infrastructure on AWS.

## Prerequisites

Before running Terraform commands, make sure you have the following prerequisites installed and configured:

- [Terraform](https://www.terraform.io/downloads.html) (version 0.12.x or later)
- [AWS CLI](https://aws.amazon.com/cli/) (version 2.x)
- AWS IAM user with appropriate permissions to manage resources (e.g., EC2, VPC, IAM, etc.)

## AWS Configuration

1. Install the AWS CLI by following the [installation instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).
2. Configure AWS CLI by running the following command and providing your AWS access key ID, secret access key, default region, and output format:

    ```bash
    aws configure
    ```

    Follow the prompts to enter your AWS credentials and preferred settings.

## Terraform Initialization

Before applying Terraform configuration, initialize the working directory containing Terraform configuration files:

```bash
terraform init
```

This command initializes various backend settings and downloads the necessary providers specified in the configuration files.

## Terraform Plan
Generate an execution plan to review proposed changes before applying them:
```bash
terraform plan
```
This command shows the execution plan, highlighting what actions Terraform will take when applying the configuration.

## Terraform Apply
Apply the Terraform configuration to create or modify resources as defined in the configuration files:

```bash
terraform apply
```

Follow the prompts to confirm and apply the changes. Review the execution plan carefully before proceeding.

Note: Ensure that you have reviewed the Terraform configuration files (*.tf) and understand the changes it will make to your AWS infrastructure before applying them.

## Cleanup
After testing or when you no longer need the provisioned resources, you can destroy them using:

```bash
terraform destroy
```
This command will remove all resources defined in the Terraform configuration files.

