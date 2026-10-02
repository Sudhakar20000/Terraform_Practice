locals {
    common_name = "${var.project}-${var.env}"
    common_tags = {
        Name      = local.common_name
        terraform = "true"
    }
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}
