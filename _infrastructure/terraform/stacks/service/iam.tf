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
            "Resource": ${jsonencode(local.secrets_arns)}
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

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow database access from private subnets"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.portfolio_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}