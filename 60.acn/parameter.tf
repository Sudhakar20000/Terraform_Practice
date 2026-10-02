resource "aws_ssm_parameter" "amazon_acm_certificate_arn" {
  name  = "/${var.project}/${var.env}/amazon_acm_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.amazon.arn
  overwrite = true
}