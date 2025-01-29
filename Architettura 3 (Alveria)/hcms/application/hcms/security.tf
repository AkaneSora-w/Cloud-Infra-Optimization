######################################
# Instance Profile
######################################

resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "${local.prefix}-profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role" "ec2_iam_role" {
  name        = local.prefix
  description = "IAM role linked to ec2 profile"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "ec2.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
    }
  })

}

###################################
# EC2 policy
###################################

resource "aws_iam_policy" "ec2_permission" {
  name = "${local.prefix}-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "S3"
        Action = [
          "s3:List*",
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "ec2_role_policies" {
  role_name   = aws_iam_role.ec2_iam_role.name
  policy_arns = [data.aws_iam_policy.managed_policy.arn, aws_iam_policy.ec2_permission.arn]
}

###################################
# RDS backup role
###################################

resource "aws_iam_role" "backup_role" {
  name        = "${local.prefix}-rds-backup"
  description = "IAM role to grant permission to backup from s3 to rds"
  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "rds.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
    }
  })
}

###################################
# RDS policy
###################################

resource "aws_iam_policy" "rds_permission" {
  name = "${local.prefix}-rds-backup"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "S3"
        Action = [
          "s3:ListBucket",
          "s3:ListMultipartUploadParts",
          "s3:GetBucketLocation",
          "s3:GetObjectAttributes",
          "s3:GetObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:GetBucketACL",
          "s3:*" //Added in console
        ]
        Effect = "Allow"
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*",
          "*" //Added in console
        ]
      },
      {
        Sid = "KMS"
        Action = [
          "kms:*" //Added in console
        ]
        Effect   = "Allow"
        Resource = var.rds_custom_mssql_config.kms_key_arn // Old value in console "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_permission" {
  policy_arn = aws_iam_policy.rds_permission.arn
  role       = aws_iam_role.backup_role.name
}

###################################
# RDS custom role and profile
###################################

resource "aws_iam_instance_profile" "rds_profile" {
  name = "AWSRDSCustomMSSQLProfile"
  role = aws_iam_role.rds_custom_role.name
}

resource "aws_iam_role" "rds_custom_role" {
  name        = "AWSRDSCustomSQLServerInstanceRole"
  description = "IAM role linked to ec2 profile"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "ec2.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
    }
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "rds_custom_role_policies" {
  role_name = aws_iam_role.rds_custom_role.name
  policy_arns = [
    data.aws_iam_policy.managed_policy_rds.arn,
    data.aws_iam_policy.managed_policy.arn,
    aws_iam_policy.rds_permission.arn,
    aws_iam_policy.ec2_permission.arn
  ]
}

resource "aws_iam_role_policy" "s3_inline_policy" {
  name = "${local.prefix}-s3-access"
  role = aws_iam_role.rds_custom_role.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect"   = "Allow",
        "Action"   = "s3:*",
        "Resource" = "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}"
      }
    ]
  })
}