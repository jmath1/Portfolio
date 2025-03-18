
resource "aws_ecr_repository" "portfolio_repo" {
  name                 = "portfolio-app"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_iam_policy" "ecr_pull_policy" {
  name        = "ECRPullPolicy"
  description = "Allow EC2 to pull from ECR"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "${aws_ecr_repository.portfolio_repo.arn}"
        }
    ]
}
EOF
}

# Attach Policy to EC2 IAM Role
resource "aws_iam_role_policy_attachment" "attach_ecr_pull" {
  role       = local.ec2_role_name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
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
            "Resource": "${aws_ecr_repository.portfolio_repo.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_ecr_policy_attach" {
  role       = local.github_runner_role_name
  policy_arn = aws_iam_policy.github_ecr_push_policy.arn
}
