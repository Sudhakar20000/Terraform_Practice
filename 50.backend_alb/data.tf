data "aws_ssm_parameter" "backend_alb_sg_id" {
    name = "/${var.project}/${var.env}/backend_alb_sg_id"
}

data "aws_ssm_parameter" "apptire_subnet_ids" {
    name = "/${var.project}/${var.env}/apptire_subnet_ids"
}