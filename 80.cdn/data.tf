data "aws_cloudfront_cache_policy" "cachingOptmized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "cachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_ssm_parameter" "amazon_acm_certificate_arn" {
    name = "/${var.project}/${var.env}/amazon_acm_certificate_arn"
}