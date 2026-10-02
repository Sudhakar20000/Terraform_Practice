resource "aws_lb" "backend_alb" {
  name               = "${local.common_name}-backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [ local.backend_alb_sg_id ]
  subnets            = local.apptire_subnet_ids

  tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}-backend_alb"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1> Success: This is a fixed response from the ALB </h1>"
      status_code  = "200"
    }
  }
}


resource "aws_route53_record" "alb" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.env}.sudhakar.shop"
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
    allow_overwrite = true
}



