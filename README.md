# Hub-and-Spoke Data Products

A general approach for an AWS Data Lake using S3, Lake Formation, Athena, and Quicksight.

![high-level](./static/Data_Overall.png)

This repository includes Terraform resources to create a Hub AWS account with dedicated networking
resources (interface endpoints and transit gateway) and spoke AWS accounts that connect to the hub 
AWS account with private networking.

![account-level](./static/Account_Deeper_Dive.png)

This assumes that you use SCP, File Gateway for S3, or other integration tools like DMS in order to load your raw data into S3. 

![glue-level](./static/Glue_Deeper_Dive.png)

## Deploying

Each spoke account is deployed via Terraform. The hub account of the organization must be pre-provisioned.

Each project is deployed separately:

```sh
cd projects/hub/
terraform apply -var-file params/default.tfvars
```

Where a variable file has been provided such as the following, where the role `Terraform` is already provisioned and is used to deploy the environment:

```hcl
region = "us-east-1"
account-id = "ACCOUNT_ID" 
app-name = "Core Network"
app-shorthand-name = "some-unique-app-name"
partition = "aws"
terraform-role = "arn:aws:iam::ACCOUNT_ID:role/Terraform"
tags = {
    "service"     = "Core VPC"
    "environment" = "prod"
    "deployment"  = "terraform"
    "cicd"        = "None"
}
cidr-block = "10.0.0.0/16"
public-subnets = {
    "us-east-1a" = "10.0.0.0/24"
    "us-east-1b" = "10.0.1.0/24"
    "us-east-1c" = "10.0.4.0/24"
}
private-subnets = {
    "us-east-1a" = "10.0.2.0/24"
    "us-east-1b" = "10.0.3.0/24"
    "us-east-1c" = "10.0.5.0/24"
}
enable-transitgateway = true
```

Or, for a spoke account:

```hcl
region = "us-east-1"
root-account-id = "ROOT_ACCOUNT_ID" 
catalog-account-id = "CATALOG_ACCOUNT_ID"
root-region = "us-east-1" 
app-name = "Government Data Account"
app-shorthand-name = "ac-government-zwy2"
owner-email = "mmehrten+anycompany-government@amazon.com"
partition = "aws"
terraform-role = "arn:aws:iam::ROOT_ACCOUNT_ID:role/Terraform"
catalog-terraform-role = "arn:aws:iam::CATALOG_ACCOUNT_ID:role/Terraform"
tags = {
    "service"     = "Government Data"
    "environment" = "prod"
    "deployment"  = "terraform"
    "cicd"        = "None"
}
cidr-block = "10.20.0.0/16"
public-subnets = {}
private-subnets = {
    "us-east-1a" = "10.20.2.0/24"
    "us-east-1b" = "10.20.3.0/24"
    "us-east-1c" = "10.20.5.0/24"
}
root-transit-gateway-id = "ROOT_TGW_ID"
pgp-key = "Key for PGP provider to create new users"
redshift-master-password = "ASillyPea1"
lf-tags = {
    "Purpose"  = ["Research", "Administrative", "Auditing"]
}
databases = {
    "bronze": [{"Key": "Purpose", "Value": "Auditing"}], 
    "silver": [{"Key": "Purpose", "Value": "Research"}], 
    "gold": [{"Key": "Purpose", "Value": "Research"}]
  }
crawlers = {
    "bronze-data": {
        "database": "bronze",
        "s3": "s3://ac-government-zwy2.us-east-1.s3.analytics/raw/",
        "schedule": "cron(0 * * * ? *)",
        "connection": "us-east-1b",
    }
    "silver-data": {
        "database": "silver",
        "s3": "s3://ac-government-zwy2.us-east-1.s3.analytics/silver/",
        "schedule": "cron(0 * * * ? *)",
        "connection": "us-east-1b",
    }
    "gold-data": {
        "database": "gold",
        "s3": "s3://ac-government-zwy2.us-east-1.s3.analytics/gold/",
        "schedule": "cron(0 * * * ? *)",
        "connection": "us-east-1b",
    }
}
lf-tag-shares = {
    "catalog-purpose-db" = {
        "principal": "447312712959",
        "key": "Purpose",
        "values": ["Research", "Administrative", "Auditing"],
        "resource": "DATABASE",
    }
    "catalog-purpose-table" = {
        "principal": "447312712959",
        "key": "Purpose",
        "values": ["Research", "Administrative", "Auditing"],
        "resource": "TABLE",
        "permissions": ["DESCRIBE", "SELECT"]
    }
    "analytics-purpose-db" = {
        "principal": "908971990554",
        "key": "Purpose",
        "values": ["Research", "Administrative", "Auditing"],
        "resource": "DATABASE",
    }
    "analytics-purpose-table" = {
        "principal": "908971990554",
        "key": "Purpose",
        "values": ["Research", "Administrative", "Auditing"],
        "resource": "TABLE",
        "permissions": ["DESCRIBE", "SELECT"]
    }
}
```