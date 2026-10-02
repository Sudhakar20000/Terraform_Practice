data "aws_ssm_parameter" "existing" {
  name            = "/${var.project}/${var.env}/vpc_id" # Fully qualified name including path
}
