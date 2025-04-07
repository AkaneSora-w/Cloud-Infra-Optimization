resource "aws_kms_alias" "rds_key_alias" {
  count         = var.create_kms_key || var.create_kms_key_shared ? 1 : 0
  name          = "alias/${local.prefix}-key"
  target_key_id = var.create_kms_key_shared ? aws_kms_key.shared_key[0].key_id : aws_kms_key.rds_key[0].key_id
}
resource "aws_kms_key" "rds_key" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "${var.owner} symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Enable rds assume role permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/alveria-hcms-prod-rds-backup/RDS-SqlServerBackupRestore"
        }
        Action   = "kms:DescribeKey"
        Resource = "arn:aws:kms:eu-west-1:339712698801:key/20d1f313-a79e-48a2-a129-e6873fb1773e"
      }

    ]
  })
}

##############################################
# Temporary configuration for Shared KMS key #
##############################################
resource "aws_kms_key" "shared_key" {
  count                   = var.create_kms_key_shared ? 1 : 0
  description             = "${var.owner} symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
}

resource "aws_kms_key_policy" "kms_shared_policy" {
  count  = var.create_kms_key_shared ? 1 : 0
  key_id = aws_kms_key.shared_key[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
      {
        "Sid" : "EnableRootUserPermissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowAWSManagedServices",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com",
            "rds.amazonaws.com",
            "s3.amazonaws.com",
            "backup.amazonaws.com"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : [
              "ec2.eu-west-1.amazonaws.com",
              "rds.eu-west-1.amazonaws.com",
              "s3.eu-west-1.amazonaws.com",
              "backup.eu-west-1.amazonaws.com"
            ],
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}

# resource "aws_kms_key_policy" "kms_rds_policy" {
#   key_id = aws_kms_key.rds_key.id
#   policy = jsonencode({
#     Id = "KMS"
#     Statement = [
#       {
#                 Sid      = "Enable rds role on kms"
#         Action = "kms:DescribeKey"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:sts::${data.aws_caller_identity.current.account_id}:assumed-role/${var.owner}-hcms-${var.environment}-rds-backup/RDS-SqlServerBackupRestore" //Role created inside application hcms (Probably is better to import the role here!)
#         }

#         Resource = aws_kms_key.rds_key[0].arn
#       },
#     ]
#     Version = "2012-10-17"
#   })

#   depends_on = [ aws_kms_key.rds_key, aws_kms_alias.rds_key_alias ]
# }