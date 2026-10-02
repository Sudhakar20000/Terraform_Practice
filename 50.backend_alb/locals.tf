

locals {
    common_name = "${var.project}-${var.env}"
    backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
    apptire_subnet_ids = split(",", data.aws_ssm_parameter.apptire_subnet_ids.value)
    common_tags = {
        Project = var.project
        Env = var.env
        Terraform = true
    }
    
}