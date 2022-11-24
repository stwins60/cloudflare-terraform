# create a cloudfront distribution module for multiple s3 buckets
resource "aws_cloudfront_distribution" "s3_distribution" {
  count = length(var.s3_buckets)
  origin {

    domain_name = "${var.s3_buckets[count.index]}.s3.${var.region}.amazonaws.com"
    origin_id   = "${var.s3_buckets[count.index]}.s3.${var.region}.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "S3 bucket distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.s3_buckets[count.index]}.s3.${var.region}.amazonaws.com"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "S3 bucket distribution"
  }
}

resource "aws_cloudfront_origin_access_identity" "s3_origin_access_identity" {
  comment = "S3 bucket origin access identity"
}
