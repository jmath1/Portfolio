data "aws_iam_policy_document" "github_allow" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_runner_provider.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository_owner}/${var.github_repository_repo}:*"]
    }
  }
}

resource "aws_iam_policy" "github_ecr_push_policy" {
  name        = "GitHubECRPushPolicy"
  description = "Allows GitHub Actions to push Docker images to ECR"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "github_runner_role" {
  name               = "GitHubRunnerRole"
  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}

resource "aws_iam_role_policy_attachment" "github_ecr_policy_attach" {
  role       = local.github_runner_role_name
  policy_arn = aws_iam_policy.github_ecr_push_policy.arn
}

