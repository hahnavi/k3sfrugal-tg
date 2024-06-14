data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
  tags               = merge({ "Name" = var.name }, var.tags)

  inline_policy {
    name = var.name
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:PutParameter"
          ],
          Resource = [
            "arn:aws:ssm:ap-southeast-3:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/${var.env}/*"
          ]
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
  tags = merge({ "Name" = var.name }, var.tags)
}
