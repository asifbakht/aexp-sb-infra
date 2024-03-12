# ALB security group
resource "aws_security_group" "load_balancer_sg" {
  name   = "${var.name_prefix}-alb-sg"
  vpc_id = aws_vpc.main_network.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group" "target_group" {
  name        = "${var.name_prefix}-lb-group"
  port        = var.web_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_network.id
}



resource "aws_security_group" "ecs_tasks_sg" {
  name   = "${var.prefix_payment_spring_boot}-ecs-tasks-sg"
  vpc_id = aws_vpc.main_network.id

  ingress {
    protocol        = "tcp"
    from_port       = var.payment_sb_port
    to_port         = var.payment_sb_port
    security_groups = ["${aws_security_group.load_balancer_sg.id}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_access_sg" {
  vpc_id = aws_vpc.main_network.id

  ingress {
    from_port       = var.payment_db_port
    to_port         = var.payment_db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_tasks_sg.id]
  }
}
