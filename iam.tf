data "aws_iam_policy_document" "assume" {
  count = var.create_iam_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "policy" {
  count = var.create_iam_role && var.iam_policy != [] ? 1 : 0

  dynamic "statement" {
    for_each = var.iam_policy

    content {
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "main" {
  count = var.create_iam_role ? 1 : 0

  name               = "${var.instance_name}-main"
  assume_role_policy = data.aws_iam_policy_document.assume[0].json

  tags = var.tags
}

resource "aws_iam_policy" "main" {
  count = var.create_iam_role && var.iam_policy != [] ? 1 : 0

  name   = "${var.instance_name}-main"
  policy = data.aws_iam_policy_document.policy[0].json
}

resource "aws_iam_role_policy_attachment" "created" {
  count = var.create_iam_role && var.iam_policy != [] ? 1 : 0

  role       = aws_iam_role.main[0].name
  policy_arn = aws_iam_policy.main[0].arn
}

resource "aws_iam_role_policy_attachment" "attached" {
  count = var.create_iam_role ? length(var.iam_policy_attachment) : 0

  role       = aws_iam_role.main[0].name
  policy_arn = var.iam_policy_attachment[count.index]
}

resource "aws_iam_instance_profile" "main" {
  name = var.instance_name
  role = var.create_iam_role ? aws_iam_role.main[0].name : var.attached_iam_role_name
}
