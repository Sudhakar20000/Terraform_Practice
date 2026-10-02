locals {
    common_name = "${var.project}-${var.env}-${var.component}"
    sg_id = data.aws_ssm_parameter.sg_id.value
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
    ami_id = data.aws_ami.joindevops.id
    apptire_subnet_ids = split(",", data.aws_ssm_parameter.apptire_subnet_ids.value)[0]
    frontend_alb_listener_arn = data.aws_ssm_parameter.frontend_alb_listener_arn.value
    alb_listener_arn = var.component == "frontend" ? local.frontend_alb_listener_arn : local.backend_alb_listener_arn
    host_header = var.component == "frontend" ? "${var.project}-${var.env}.${var.domain}" : "${var.component}.backend-alb-${var.env}.${var.domain}"
    common_tags = {
        Project = var.project
        Env = var.env
        Terraform = true
    }
    
}