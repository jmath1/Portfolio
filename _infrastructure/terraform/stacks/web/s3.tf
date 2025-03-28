resource "aws_s3_bucket" "portfolio_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }

}

resource "aws_s3_bucket_public_access_block" "_" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "PublicReadGetObject",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.portfolio_bucket.arn}/*"
      }
    ]
  })
}



resource "aws_iam_role_policy" "uploader_policy" {
  name = "uploader-policy"
  role = aws_iam_role.portfolio_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource = "${aws_s3_bucket.portfolio_bucket.arn}/*"
      }
    ]
  })
}
