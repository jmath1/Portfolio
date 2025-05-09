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
                "ecr:BatchGetImage",
                "ecr:DescribeRepositories"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "secrets_read_policy" {
  name        = "SecretsReadPolicy"
  description = "Allow EC2 to read secrets"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "portfolio_role" {
  name = "portfolio_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.portfolio_role.name
}

resource "aws_iam_role_policy_attachment" "attach_ecr_pull" {
  role       = aws_iam_role.portfolio_role.name
  policy_arn = aws_iam_policy.ecr_pull_policy.arn
}



resource "aws_iam_role_policy_attachment" "attach_secrets_read" {
  role       = aws_iam_role.portfolio_role.name
  policy_arn = aws_iam_policy.secrets_read_policy.arn
}
