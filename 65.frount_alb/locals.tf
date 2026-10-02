locals {
    frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
    frounttir_subnet_ids = split(",", data.aws_ssm_parameter.frounttir_subnet_ids.value)
    amazon_acm_certificate_arn = data.aws_ssm_parameter.amazon_acm_certificate_arn.value
    common_name = "${var.project}-${var.env}"
    common_tags = {
        Project = var.project
        Env = var.env
        Terraform = true
    }
}