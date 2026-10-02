resource "aws_ssm_parameter" "sg_id" {
  name  = "/roboshop/${var.env}/mysql_root_password"
  type  = "SecureString"
  value = var.mysql_root_password
  overwrite = true
}