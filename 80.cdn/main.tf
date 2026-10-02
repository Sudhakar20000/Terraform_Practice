resource "aws_cloudfront_distribution" "amazon" {
  
  origin {
    domain_name              = "${var.project}-${var.env}.${var.domain}"
    origin_id                = "${var.project}-${var.env}.${var.domain}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # Enforce HTTPS to ALB
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Some comment"
  
  # CDN name
  aliases = ["${var.project}-cdn.${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.project}-${var.env}.${var.domain}"

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    cache_policy_id = local.cachingDisabled
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.env}.${var.domain}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptmized
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/videos/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${var.project}-${var.env}.${var.domain}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
    cache_policy_id = local.cachingOptmized
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(
    {
        Name = "${var.project}-${var.env}"
    },
    local.common_tags
  )

  viewer_certificate {
    acm_certificate_arn = local.amazon_acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "${var.project}-cdn.${var.domain}"
  type    = "A"

  alias {
    # AWS details
    name                   = aws_cloudfront_distribution.amazon.domain_name
    zone_id                = aws_cloudfront_distribution.amazon.hosted_zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}