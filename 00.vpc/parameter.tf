resource "aws_ssm_parameter" "vpc_id" {
  type  = "String"
  name  = "/${var.project}/${var.env}/vpc_id"
  value = aws_vpc.main.id
  overwrite = true
}

resource "aws_ssm_parameter" "frounttir_subnet_ids" {
type  = "String"
  name  = "/${var.project}/${var.env}/frounttir_subnet_ids"
  value = join(",", aws_subnet.frounttir[*].id)
  overwrite = true
}

resource "aws_ssm_parameter" "apptir_subnet_ids" {
 type  = "String"
  name  = "/${var.project}/${var.env}/apptir_subnet_ids"
  value = join(",", aws_subnet.apptir[*].id)
  overwrite = true
}

resource "aws_ssm_parameter" "dbtir_subnet_ids" {
  type  = "String"
  name  = "/${var.project}/${var.env}/dbtir_subnet_ids"
  value = join(",", aws_subnet.dbtir[*].id)
  overwrite = true
}