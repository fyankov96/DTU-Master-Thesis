# Master Thesis

This repository contains a collection of Terraform modules and configurations for deploying a scalable and secure architecture on Microsoft Azure. These modules and configurations are designed to be flexible, modular, and easily adaptable to your specific infrastructure requirements.

## Prerequisites

Before using this repository, please ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (version >= 2.0)

## Features

The Azure Terraform Blueprint includes:

- Resource Group and Naming Convention module
- Virtual Network and Subnet module
- Network Security Group module
- Virtual Machine module
- Storage Account module
- Azure App Service module
- Azure Key Vault module

## Quick Start

1. Clone this repository:

`git clone git@github.com:fyankov96/DTU-Master-Thesis.git`

`cd DTU-Master-Thesis`

`cd azure-infrastructure-terraform`

2. Log in to your Azure account:

`az login`

3. Initialize Terraform:

`terraform init`

4. Customize the `terraform.tfvars` file with your desired infrastructure settings.

5. Deploy the infrastructure:

`terraform apply`

6. To destroy the deployed resources, run:

`terraform destroy`

## License

This project is licensed under the [MIT License]([https://github.com/fyankov96/azure-terraform-blueprint/blob/main/LICENSE](https://github.com/fyankov96/DTU-Master-Thesis/blob/main/LICENSE)).

## Support

If you encounter any issues or have questions, please open a GitHub issue or reach out to the maintainers.
