resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "access to site"
  description                       = "access to site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "site_access" {

  depends_on = [aws_s3_bucket.site_origin, aws_cloudfront_origin_access_control.site_access]

  enabled = true

  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.site_origin.id
    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name              = aws_s3_bucket.site_origin.bucket_domain_name
    origin_id                = aws_s3_bucket.site_origin.id
    origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}