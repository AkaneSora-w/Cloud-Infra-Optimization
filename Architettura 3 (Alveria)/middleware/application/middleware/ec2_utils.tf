######################################
# KEYS
######################################

resource "aws_key_pair" "ec2_key" {
  key_name   = "${local.prefix}-key"
  public_key = file("${path.cwd}/key.pem")
}

######################################
# Instance Profile
######################################

resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "${local.prefix}-profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_iam_role" "ec2_iam_role" {
  name                = local.prefix
  description         = "IAM role linked to ec2 profile"
  managed_policy_arns = [data.aws_iam_policy.managed_policy.arn]
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

  lifecycle {
    ignore_changes = [managed_policy_arns]
  }
}

moved {
  from = aws_iam_role.ec2_iam_role[0]
  to   = aws_iam_role.ec2_iam_role
}

moved {
  from = aws_iam_instance_profile.ec2_iam_profile[0]
  to   = aws_iam_instance_profile.ec2_iam_profile
}