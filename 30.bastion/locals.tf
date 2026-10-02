locals {
    common_name = "${var.project}-${var.env}"
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    frounttir_subnet_id = split(",", data.aws_ssm_parameter.frounttir_subnet_ids.value)[0]
    common_tags = {
        Project = var.project
        Env = var.env
        Terraform = true
    }
    
}