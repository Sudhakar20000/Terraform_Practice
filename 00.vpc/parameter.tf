resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.env}/vpc_id"
  value = aws_vpc.main.id
  overwrite = true
}

resource "aws_ssm_parameter" "frounttir_subnet_ids" {
  name  = "/${var.project}/${var.env}/frounttir_subnet_ids"
  value = join(",", aws_subnet.frounttir.frounttir_subnet_ids)
  overwrite = true
}

resource "aws_ssm_parameter" "apptir_subnet_ids" {
  name  = "/${var.project}/${var.env}/apptir_subnet_ids"
  value = join(",", aws_subnet.apptir.apptir_subnet_ids)
  overwrite = true
}

resource "aws_ssm_parameter" "dbtir_subnet_ids" {
  name  = "/${var.project}/${var.env}/dbtir_subnet_ids"
  value = join(",", aws_subnet.dbtir.dbtir_subnet_ids)
  overwrite = true
}