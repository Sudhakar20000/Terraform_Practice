resource "aws_ssm_parameter" "aws_lb_listener_arn" {
  name  = "/${var.project}/${var.env}/frontend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
  overwrite = true
}