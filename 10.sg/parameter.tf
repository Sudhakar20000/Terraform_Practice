resource "aws_ssm_parameter" "sg_ids" {
    count = length(var.sg_name)
type  = "String"
  name  = "/${var.project}/${var.env}/${var.sg_name[count.index]}_sg_ids"
  value = aws_security_group.sg[count.index].id
  overwrite = true
}
