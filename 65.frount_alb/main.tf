resource "aws_lb" "frontend_alb" {
  name               = "${local.common_name}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ local.frontend_alb_sg_id ]
  subnets            = local.frounttir_subnet_ids

  tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}-"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06" 
  certificate_arn   = local.amazon_acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1> Success: This is a fixed response from the frountend ALB </h1>"
      status_code  = "200"
    }
  }
}


resource "aws_route53_record" "alb" {
  zone_id = var.zone_id
  name    = "${var.project}-${var.env}.sudhakar.shop"
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
    allow_overwrite = true
}