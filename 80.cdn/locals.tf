locals {
  cachingOptmized = data.aws_cloudfront_cache_policy.cachingOptmized.id
  cachingDisabled = data.aws_cloudfront_cache_policy.cachingDisabled.id
  common_tags = {
        Project = "${var.project}"
        Environment = "${var.env}"
        Terraform = "true"
   }
  amazon_acm_certificate_arn = data.aws_ssm_parameter.amazon_acm_certificate_arn.value
}