data "aws_ssm_parameter" "frontend_alb_sg_id" {
    name = "/${var.project}/${var.env}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "frounttir_subnet_ids" {
    name = "/${var.project}/${var.env}/frounttir_subnet_ids"
}
data "aws_ssm_parameter" "amazon_acm_certificate_arn" {
    name = "/${var.project}/${var.env}/amazon_acm_certificate_arn"
}