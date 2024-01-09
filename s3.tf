resource "aws_s3_bucket" "site_origin" {
  bucket = var.bucket_name
  tags = {
    environment = "labs"
  }
}

resource "aws_s3_bucket_public_access_block" "PAB" {
  bucket = aws_s3_bucket.site_origin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "site_origin" {
  bucket = aws_s3_bucket.site_origin.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.site_origin.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "content" {
  depends_on             = [aws_s3_bucket.site_origin]
  bucket                 = aws_s3_bucket.site_origin.id
  key                    = "index.html"
  source                 = "./index.html"
  server_side_encryption = "AES256"
  content_type           = "text/html"
}

resource "aws_s3_bucket_policy" "origin" {
  depends_on = [data.aws_iam_policy_document.origin]

  bucket = aws_s3_bucket.site_origin.id
  policy = data.aws_iam_policy_document.origin.json

}


data "aws_iam_policy_document" "origin" {

  depends_on = [aws_cloudfront_distribution.site_access, aws_s3_bucket.site_origin]

  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]


    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.site_origin.bucket}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.site_access.arn
      ]
    }

  }
}