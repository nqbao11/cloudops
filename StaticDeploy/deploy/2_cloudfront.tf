locals {
  s3_origin_id = "mywebsite"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
        origin_id = local.s3_origin_id
    }
    
    enabled             = true
    is_ipv6_enabled     = true

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id
        viewer_protocol_policy = "allow-all"
        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
  }
}