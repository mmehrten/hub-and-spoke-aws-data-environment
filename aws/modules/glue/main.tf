/*
* Create a Glue catalog and database.
*/

resource "aws_lakeformation_data_lake_settings" "main" {
  admins = [var.terraform-role, "arn:${var.partition}:iam::${var.account-id}:role/Admin"]
}

resource "aws_lakeformation_lf_tag" "main" {
  for_each = var.lf-tags
  key      = each.key
  values   = each.value
}

resource "aws_iam_role" "client" {
  name = "GlueClientRole"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueDataBrewServiceRole",
    "arn:aws:iam::aws:policy/AwsGlueDataBrewFullAccessPolicy",
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : ["sts:AssumeRole"],
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : ["arn:${var.partition}:iam::${var.account-id}:role/Admin"]
      },
      "Sid" : "AllowAdminToAssume"
      }, {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : ["glue.amazonaws.com", "databrew.amazonaws.com", "dms.amazonaws.com"]
      },
      "Action" : "sts:AssumeRole"
      }
    ]
  })

  # TODO: Grant AmazonAthenaFullAccess? AWSGlueServiceRole?
  inline_policy {
    name = "AllowGlueS3Access"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CloudwatchMetrics",
          "Effect" : "Allow",
          "Action" : "cloudwatch:PutMetricData",
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "cloudwatch:namespace" : "Glue"
            }
          }
        },
        {
          "Sid" : "CloudwatchLogs",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:${var.partition}:logs:*:*:/aws-glue/*",
            "arn:${var.partition}:logs:*:*:/aws-lakeformation-acceleration/*",
          ]
        },
        {
          "Sid" : "Storageallbuckets",
          "Action" : [
            "s3:GetBucketLocation",
            "s3:ListBucket"
          ],
          "Resource" : concat(var.read-bucket-arns, var.write-bucket-arns),
          "Effect" : "Allow"
        },
        {
          "Sid" : "Readandwritebuckets",
          "Action" : [
            "s3:*Object",
            "s3:PutObjectAcl",
            "s3:*Multipart*",
            "kms:GenerateDataKey",
            "kms:Decrypt",
            "kms:Encrypt",
          ],
          "Resource" : var.write-bucket-arns,
          "Effect" : "Allow"
        },
        {
          "Sid" : "Readonlybuckets",
          "Action" : [
            "s3:GetObject",
            "kms:Decrypt",
            "kms:GenerateDataKey"
          ],
          "Resource" : var.read-bucket-arns,
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetBucketLocation",
            "s3:ListBucket",
            "s3:ListAllMyBuckets",
            "s3:GetBucketAcl",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeRouteTables",
            "ec2:CreateNetworkInterface",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcAttribute",
            "iam:ListRolePolicies",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "cloudwatch:PutMetricData"
          ],
          "Resource" : [
            "*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:CreateBucket"
          ],
          "Resource" : [
            "arn:${var.partition}:s3:::aws-glue-*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "arn:${var.partition}:s3:::aws-glue-*/*",
            "arn:${var.partition}:s3:::*/*aws-glue-*/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "arn:${var.partition}:s3:::crawler-public*",
            "arn:${var.partition}:s3:::aws-glue-*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateTags",
            "ec2:DeleteTags"
          ],
          "Condition" : {
            "ForAllValues:StringEquals" : {
              "aws:TagKeys" : [
                "aws-glue-service-resource"
              ]
            }
          },
          "Resource" : [
            "arn:${var.partition}:ec2:*:*:network-interface/*",
            "arn:${var.partition}:ec2:*:*:security-group/*",
            "arn:${var.partition}:ec2:*:*:instance/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : ["iam:PassRole"],
          "Resource" : [
            "arn:${var.partition}:iam::${var.account-id}:role/LakeFormationWorkflowRole"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "lakeformation:GetDataAccess",
            "lakeformation:GrantPermissions",
            "glue:GetTable",
            "glue:GetTables",
            "glue:SearchTables",
            "glue:GetDatabase",
            "glue:GetDatabases",
            "glue:GetPartitions",
            "lakeformation:GetResourceLFTags",
            "lakeformation:ListLFTags",
            "lakeformation:GetLFTag",
            "lakeformation:SearchTablesByLFTags",
            "lakeformation:SearchDatabasesByLFTags",
            "glue:UpdateTable",
            "lakeformation:StartQueryPlanning",
            "lakeformation:GetQueryState",
            "lakeformation:GetWorkUnits",
            "lakeformation:GetWorkUnitResults",
            "lakeformation:GetQueryStatistics",
            "lakeformation:StartTransaction",
            "lakeformation:CommitTransaction",
            "lakeformation:CancelTransaction",
            "lakeformation:ExtendTransaction",
            "lakeformation:DescribeTransaction",
            "lakeformation:ListTransactions",
            "lakeformation:GetTableObjects",
            "lakeformation:UpdateTableObjects",
            "lakeformation:DeleteObjectsOnCancel",
            "lakeformation:UpdateTableStorageOptimizer",
            "lakeformation:ListTableStorageOptimizers"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "accesstoconnections",
          "Action" : [
            "glue:GetConnection",
            "glue:GetConnections",
            "glue:CreateDatabase",
            "glue:DeleteDatabase",
            "glue:GetUserDefinedFunctions",
            "glue:SearchTables",
            "glue:BatchCreatePartition",
            "glue:BatchGetPartition",
            "glue:CreatePartitionIndex",
            "glue:GetTableVersions",
            "glue:GetPartitions",
            "glue:DeleteTableVersion",
            "glue:UpdateTable",
            "glue:DeleteTable",
            "glue:DeletePartitionIndex",
            "glue:GetTableVersion",
            "glue:UpdateColumnStatisticsForTable",
            "glue:CreatePartition",
            "glue:UpdateDatabase",
            "glue:CreateTable",
            "glue:GetTables",
            "glue:GetDatabases",
            "glue:GetTable",
            "glue:GetDatabase",
            "glue:GetPartition",
            "glue:UpdateColumnStatisticsForPartition",
            "glue:CreateDatabase",
            "glue:BatchDeleteTableVersion",
            "glue:BatchDeleteTable",
            "glue:DeletePartition",
            "glue:GetUserDefinedFunctions",
            "lakeformation:ListResources",
            "lakeformation:BatchGrantPermissions",
            "lakeformation:ListPermissions"
          ],
          "Resource" : [
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:connection/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*"
          ],
          "Effect" : "Allow"
        },
      ]
    })
  }
}

resource "aws_iam_role" "client-super" {
  name = "GlueSuperUserRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : ["sts:AssumeRole"],
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : ["arn:${var.partition}:iam::${var.account-id}:role/Admin"]
      },
      "Sid" : "AllowAdminToAssume"
      }, {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "glue.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "AllowGlueS3Access"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CloudwatchMetrics",
          "Effect" : "Allow",
          "Action" : "cloudwatch:PutMetricData",
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "cloudwatch:namespace" : "Glue"
            }
          }
        },
        {
          "Sid" : "CloudwatchLogs",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:PutLogEvents"
          ],
          "Resource" : [
            "arn:${var.partition}:logs:*:*:/aws-glue/*"
          ]
        },
        {
          "Sid" : "accesstoconnections",
          "Action" : [
            "glue:GetConnection",
            "glue:GetConnections"
          ],
          "Resource" : [
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:connection/*"
          ],
          "Effect" : "Allow"
        },
        {
          "Sid" : "AllowDefaultDatabaseAccess",
          "Action" : [
            "glue:GetUserDefinedFunctions",
            "glue:CreateDatabase"
          ],
          "Resource" : [
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*"
          ],
          "Effect" : "Allow"
        },
        {
          "Sid" : "Readandwritedatabases",
          "Action" : [
            "glue:SearchTables",
            "glue:BatchCreatePartition",
            "glue:CreatePartitionIndex",
            "glue:DeleteDatabase",
            "glue:GetTableVersions",
            "glue:GetPartitions",
            "glue:DeleteTableVersion",
            "glue:UpdateTable",
            "glue:DeleteTable",
            "glue:DeletePartitionIndex",
            "glue:GetTableVersion",
            "glue:UpdateColumnStatisticsForTable",
            "glue:CreatePartition",
            "glue:UpdateDatabase",
            "glue:CreateTable",
            "glue:GetTables",
            "glue:GetDatabases",
            "glue:GetTable",
            "glue:GetDatabase",
            "glue:GetPartition",
            "glue:UpdateColumnStatisticsForPartition",
            "glue:CreateDatabase",
            "glue:BatchDeleteTableVersion",
            "glue:BatchDeleteTable",
            "glue:DeletePartition",
            "glue:GetUserDefinedFunctions",
            "lakeformation:ListResources",
            "lakeformation:BatchGrantPermissions",
            "lakeformation:ListPermissions"
          ],
          "Resource" : [
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*"
          ],
          "Effect" : "Allow"
        },
        {
          "Sid" : "Readonlydatabases",
          "Action" : [
            "glue:SearchTables",
            "glue:GetTableVersions",
            "glue:GetPartitions",
            "glue:GetTableVersion",
            "glue:GetTables",
            "glue:GetDatabases",
            "glue:GetTable",
            "glue:GetDatabase",
            "glue:GetPartition",
            "lakeformation:ListResources",
            "lakeformation:ListPermissions"
          ],
          "Resource" : [
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/default",
            "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/global_temp"
          ],
          "Effect" : "Allow"
        },
        {
          "Sid" : "Readandwritebuckets",
          "Action" : [
            "s3:*Object",
            "s3:PutObjectAcl",
            "s3:*Multipart*",
            "kms:GenerateDataKey",
            "kms:Decrypt",
            "kms:Encrypt",
          ],
          "Resource" : [
            "arn:${var.partition}:s3:::${var.base-name}*",
            "arn:${var.partition}:s3:::${var.base-name}*/*",
            "arn:${var.partition}:kms:${var.region}:${var.account-id}:key/*"
          ],
          "Effect" : "Allow"
        }
      ]
    })
  }
}

resource "aws_iam_role" "runtime" {
  name                = "AwsGlueSessionUserRestrictedServiceRole-GlueRuntimeRole"
  managed_policy_arns = ["arn:${var.partition}:iam::aws:policy/service-role/AwsGlueSessionUserRestrictedServiceRole"]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "glue.amazonaws.com"
          ]
        },
        "Action" : [
          "sts:AssumeRole"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "etl" {
  name = "ETLPipelineDeveloper"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : ["sts:AssumeRole"],
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : ["arn:${var.partition}:iam::${var.account-id}:role/Admin"]
      },
      "Sid" : "AllowAdminToAssume"
      }, {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "glue.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "consumer" {
  name = "DataConsumer"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Action" : ["sts:AssumeRole"],
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : ["arn:${var.partition}:iam::${var.account-id}:role/Admin"]
      },
      "Sid" : "AllowAdminToAssume"
      }, {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "glue.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_glue_catalog_database" "source-db" {
  for_each    = var.databases
  name        = each.key
  description = "Database for Glue jobs."
}

resource "aws_lakeformation_permissions" "etl-tag-share" {
  for_each                      = var.lf-tags
  principal                     = aws_iam_role.etl.arn
  permissions                   = ["ASSOCIATE", "DESCRIBE"]
  permissions_with_grant_option = ["ASSOCIATE", "DESCRIBE"]
  lf_tag {
    key    = each.key
    values = each.value
  }
}

resource "aws_lakeformation_permissions" "client-tag-share" {
  for_each                      = var.lf-tags
  principal                     = aws_iam_role.client.arn
  permissions                   = ["ASSOCIATE", "DESCRIBE"]
  permissions_with_grant_option = ["ASSOCIATE", "DESCRIBE"]
  lf_tag {
    key    = each.key
    values = each.value
  }
}

resource "aws_lakeformation_permissions" "admin-tag-share" {
  for_each = {
    for o in flatten(
      [for key, value in var.lf-tags : [
        for principal in [var.terraform-role, "arn:${var.partition}:iam::${var.account-id}:role/Admin"] :
        { "key" : key, "value" : value, "principal" : principal }
        ]
      ]
    ) : "${o.key}_${o.principal}" => o
  }
  principal                     = each.value.principal
  permissions                   = ["ASSOCIATE", "DESCRIBE"]
  permissions_with_grant_option = ["ASSOCIATE", "DESCRIBE"]
  lf_tag {
    key    = each.value.key
    values = each.value.value
  }
}

resource "aws_lakeformation_resource_lf_tags" "source-db" {
  depends_on = [aws_lakeformation_permissions.admin-tag-share]
  for_each   = { for o in flatten([for k, tags in var.databases : [for v in tags : { "db" : k, "key" : v.Key, "value" : v.Value }]]) : "${o.key}_${o.value}_${o.db}" => o }
  database {
    name = each.value.db
  }

  lf_tag {
    key   = each.value.key
    value = each.value.value
  }
  # # LF Tags get grouped together on subsequent calls - can ignore these instead
  # lifecycle {
  #   ignore_changes = [lf_tag]
  # }
}

resource "aws_security_group" "main" {
  name        = "${var.base-name}.sg.glue"
  description = "Security group for AWS Glue."
  vpc_id      = var.vpc-id

  tags = {
    Name = "${var.base-name}.sg.glue"
  }
}

resource "aws_security_group_rule" "ingress" {
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.main.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

data "aws_subnets" "main" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_subnet" "main" {
  for_each = toset(data.aws_subnets.main.ids)
  id       = each.value
}

resource "aws_glue_connection" "main" {
  for_each        = data.aws_subnet.main
  connection_type = "NETWORK"
  name            = each.value.availability_zone
  description     = "Connection for ${each.value.availability_zone}"

  physical_connection_requirements {
    availability_zone      = each.value.availability_zone
    security_group_id_list = [aws_security_group.main.id]
    subnet_id              = each.value.id
  }
}

locals {
  s3_buckets = {
    for o in distinct(
      [
        for o in concat(var.read-bucket-arns, var.write-bucket-arns) :
        o if length(regexall(".*:s3.*", o)) > 0 && length(regexall("\\*$", o)) == 0
      ]
    ) :
    o => o
  }
  s3_buckets_with_regex = {
    for o in distinct(
      [
        for o in concat(var.read-bucket-arns, var.write-bucket-arns) :
        o if length(regexall(".*:s3.*", o)) > 0
      ]
    ) :
    o => o
  }
}

resource "aws_lakeformation_resource" "buckets" {
  for_each = local.s3_buckets
  arn      = each.value
  role_arn = aws_iam_role.client.arn
}

resource "aws_lakeformation_permissions" "client-data-source" {
  for_each    = local.s3_buckets
  principal   = aws_iam_role.client.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = each.value
  }
}

resource "aws_lakeformation_permissions" "etl-data-source" {
  for_each    = local.s3_buckets
  principal   = aws_iam_role.etl.arn
  permissions = ["DATA_LOCATION_ACCESS"]

  data_location {
    arn = each.value
  }
}

resource "aws_lakeformation_permissions" "tag-tag-shares" {
  for_each = {
    for o in flatten([
      for key, values in var.lf-tags : [
        for principal in distinct([for k, v in var.lf-tag-shares : v.principal]) : [
          { "key" : key, "values" : values, "principal" : principal }
        ]
      ]
    ]) :
    "${o.key}_${o.principal}" => o
  }
  principal                     = each.value.principal
  permissions                   = ["ASSOCIATE", "DESCRIBE"]
  permissions_with_grant_option = ["ASSOCIATE", "DESCRIBE"]
  lf_tag {
    key    = each.value.key
    values = each.value.values
  }
}

resource "aws_lakeformation_permissions" "tag-table-shares" {
  depends_on                    = [aws_lakeformation_permissions.admin-tag-share]
  for_each                      = var.lf-tag-shares
  principal                     = each.value.principal
  permissions                   = lookup(each.value, "permissions", ["DESCRIBE"])
  permissions_with_grant_option = lookup(each.value, "permissions_with_grant_option", lookup(each.value, "permissions", ["DESCRIBE"]))
  lf_tag_policy {
    resource_type = each.value.resource

    expression {
      key    = each.value.key
      values = each.value.values
    }
  }
}

resource "aws_lakeformation_permissions" "etl-dev" {
  depends_on  = [aws_lakeformation_permissions.admin-tag-share]
  for_each    = var.lf-tags
  principal   = aws_iam_role.etl.arn
  permissions = ["ALL"]
  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = each.key
      values = each.value
    }
  }
}

resource "aws_lakeformation_permissions" "client" {
  depends_on  = [aws_lakeformation_permissions.admin-tag-share]
  for_each    = var.lf-tags
  principal   = aws_iam_role.client.arn
  permissions = ["ALL"]
  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = each.key
      values = each.value
    }
  }
}

resource "aws_lakeformation_permissions" "consumer-db" {
  depends_on  = [aws_lakeformation_permissions.admin-tag-share]
  for_each    = var.lf-tags
  principal   = aws_iam_role.consumer.arn
  permissions = ["DESCRIBE"]
  lf_tag_policy {
    resource_type = "DATABASE"

    expression {
      key    = each.key
      values = each.value
    }
  }
}

resource "aws_lakeformation_permissions" "consumer-tables" {
  depends_on  = [aws_lakeformation_permissions.admin-tag-share]
  for_each    = var.lf-tags
  principal   = aws_iam_role.consumer.arn
  permissions = ["DESCRIBE", "SELECT"]
  lf_tag_policy {
    resource_type = "TABLE"

    expression {
      key    = each.key
      values = each.value
    }
  }
}

resource "aws_glue_resource_policy" "main" {
  enable_hybrid = "TRUE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "glue:*"
        ],
        "Principal" : {
          "AWS" : distinct([for k, v in var.lf-tag-shares : v.principal])
        },
        "Resource" : [
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*",
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*",
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog"
        ],
        "Condition" : {
          "Bool" : {
            "glue:EvaluatedByLakeFormationTags" : true
          }
      } },
      {
        "Effect" : "Allow",
        "Action" : [
          "glue:ShareResource"
        ],
        "Principal" : {
          "Service" : "ram.amazonaws.com"
        },
        "Resource" : [
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:table/*/*",
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:database/*",
          "arn:${var.partition}:glue:${var.region}:${var.account-id}:catalog"
        ]
      }
  ] })
}

resource "aws_glue_crawler" "main" {
  for_each      = var.crawlers
  database_name = each.value.database
  name          = each.key
  role          = aws_iam_role.client.arn
  schedule      = lookup(each.value, "schedule", null)
  lineage_configuration {
    crawler_lineage_settings = "ENABLE"
  }
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  s3_target {
    path            = each.value.s3
    connection_name = lookup(each.value, "connection", "${var.region}a")
  }

  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  configuration = jsonencode(
    {
      Version = 1
      Grouping = {
        TableLevelConfiguration = tonumber(lookup(each.value, "table_level", 2))
      }
    }
  )
}

resource "aws_glue_connection" "redshift-serverless" {
  connection_type = "JDBC"
  name            = "redshift-serverless"
  description     = "Connection for Redshift Serverless"

  connection_properties = {
    JDBC_CONNECTION_URL = var.redshift-jdbc-url
    USERNAME            = "admin"
    PASSWORD            = var.redshift-password
  }

  physical_connection_requirements {
    availability_zone      = values(data.aws_subnet.main)[0].availability_zone
    security_group_id_list = [aws_security_group.main.id]
    subnet_id              = values(data.aws_subnet.main)[0].id
  }
}

resource "aws_glue_crawler" "redshift" {
  database_name = "bronze"
  name          = "redshift-serverless"
  role          = aws_iam_role.client.arn
  schedule      = null
  lineage_configuration {
    crawler_lineage_settings = "ENABLE"
  }
  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }
  jdbc_target {
    connection_name = aws_glue_connection.redshift-serverless.name
    path            = "${element(split("/", var.redshift-jdbc-url), length(split("/", var.redshift-jdbc-url)) - 1)}/%"
  }
  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}