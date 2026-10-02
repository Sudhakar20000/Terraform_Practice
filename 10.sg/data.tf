data "aws_ssm_parameter" "vpc_id" {
  name            = "/${var.project}/${var.env}/vpc_id" # Fully qualified name including path
}
