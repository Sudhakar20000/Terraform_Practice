resource "aws_instance" "main" {
  ami           = data.aws_ami.joindevops.id
  instance_type = "t3.micro"
  vpc_security_group_ids  = [ local.sg_id ]
  subnet_id = local.apptire_subnet_ids

    tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}"
    }
  )
}

  
resource "terraform_data" "main" {
  triggers_replace = [
    aws_instance.main.id
  ]

 connection {
    type        = "ssh"
    user        = "ec2-user"
    password    =  "DevOps321"
    host        = aws_instance.main.private_ip
  }

   provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh ${var.component} ${var.env} ${var.app_version}"
    ]
  }
}

resource "aws_ec2_instance_state" "stop" {
  instance_id = aws_instance.main.id
  state       = "stopped" 
  depends_on = [terraform_data.main]
}

resource "aws_ami_from_instance" "main" {
  name               ="${local.common_name}-${var.app_version}-${aws_instance.main.id}"
  source_instance_id = aws_instance.main.id
  depends_on = [aws_ec2_instance_state.stop]

  tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}"
    }
  )
}

resource "aws_launch_template" "main" {
  name = "${local.common_name}"
  image_id = aws_ami_from_instance.main.id

  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  vpc_security_group_ids = [ local.sg_id ]
    update_default_version = true 

  tag_specifications {
    resource_type = "instance"

    tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}-${var.app_version}-${aws_instance.main.id}"
    }
  )
  }
 tag_specifications {
    resource_type = "volume"

    tags = merge (
    local.common_tags,
    {
    Name = "${local.common_name}-${var.app_version}-${aws_instance.main.id}"
    }
  )
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${local.common_name}"
  port        = var.component == "frontend" ? "80" : "8080"
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  deregistration_delay = 30


  health_check {
    enabled             = true
    path                =  var.component == "frontend" ? "/" : "/health"
    matcher             = "200-299"
    port                = var.component == "frontend" ? "80" : "8080"
    protocol            = "HTTP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${local.common_name}"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = false
   launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.apptire_subnet_ids]
  target_group_arns = [aws_lb_target_group.main.arn]

   instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
 
 dynamic "tag" {
    for_each = merge (
        {
            Name = "${local.common_name}"
        },
        local.common_tags
    )
  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
 }
    timeouts {
    delete = "15m"
  }
 }


resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   =  "${local.common_name}"
  autoscaling_group_name = aws_autoscaling_group.main.name 
  policy_type            = "TargetTrackingScaling"
    estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0 
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = local.alb_listener_arn
  priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = [local.host_header]
    }
  }
}