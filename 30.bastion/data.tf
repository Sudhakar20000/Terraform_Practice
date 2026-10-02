data "aws_ssm_parameter" "bastion_sg_id" {
    name = "/${var.project}/${var.env}/bastion_sg_id"
}

data "aws_ssm_parameter" "frounttir_subnet_ids" {
    name = "/${var.project}/${var.env}/frounttir_subnet_ids"
}

data "aws_ami" "devops" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}