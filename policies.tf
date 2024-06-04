resource "aws_iam_policy" "cloudfront_policy" {
  name        = "cloudfront_policy"
  description = "Policy for CloudFront invalidation"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "VisualEditor0",
        Effect = "Allow",
        Action = [
          "cloudfront:GetInvalidation",
          "cloudfront:CreateInvalidation"
        ],
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.cf_distribution.id}"

      }
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.s3_policy_name
  description = "Policy for S3 access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_cloudfront_policy" {
  name       = "attach_cloudfront_policy"
  policy_arn = aws_iam_policy.cloudfront_policy.arn
  groups     = [aws_iam_group.frontend_group.name]
}

resource "aws_iam_policy_attachment" "attach_s3_policy" {
  name       = "attach_s3_policy"
  policy_arn = aws_iam_policy.s3_policy.arn
  groups     = [aws_iam_group.frontend_group.name]
}

data "aws_caller_identity" "current" {}