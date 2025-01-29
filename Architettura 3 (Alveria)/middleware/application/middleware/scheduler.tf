resource "aws_cloudformation_stack" "scheduler" {
  name = "scheduler-stack-${var.owner}-${var.service_name}"

  parameters = {
    StartedTags = ""
    StoppedTags = ""
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]

  template_url = "https://s3.amazonaws.com/solutions-reference/instance-scheduler-on-aws/latest/instance-scheduler-on-aws.template"
}