# define ALB
resource "aws_alb" "alb" {
  name            = "${var.name_prefix}-alb"
  subnets         = flatten(["${aws_subnet.public_subnet.*.id}"])
  security_groups = ["${aws_security_group.load_balancer_sg.id}"]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.name_prefix}-alb-target-group"
  port        = var.web_port
  protocol    = var.alb_protocol
  vpc_id      = aws_vpc.main_network.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "4"
    unhealthy_threshold = "4"
    timeout             = "4"
    interval            = "7"
    protocol            = var.alb_protocol
    matcher             = "200"
    path                = var.healthcheck_path
  }
}

resource "aws_alb_listener" "load_balancer_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.web_port
  protocol          = var.alb_protocol

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.id
    type             = "forward"
  }
}


resource "aws_lb_listener_rule" "payment_listener" {
  listener_arn = aws_alb_listener.load_balancer_listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payment_service_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/api/v1/payment*"]
    }
  }
}

resource "aws_lb_target_group" "payment_service_target_group" {
  name        = "payment-service-tg"
  port        = var.web_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_network.id
  health_check {
    matcher             = "200,301,302"
    path                = "/api/v1/payment/actuator/health"
    healthy_threshold   = 4
    unhealthy_threshold = 5
    timeout             = 6
    interval            = 60
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

