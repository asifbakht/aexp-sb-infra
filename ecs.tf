# define Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name_prefix}-cluster"
}


resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.prefix_payment_spring_boot}-task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.prefix_payment_spring_boot}-container",
      "image": "${var.payment_image}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.web_port},
          "hostPort": ${var.web_port}
        },
        {
          "containerPort": ${var.payment_sb_port},
          "hostPort": ${var.payment_sb_port},
          "name": "${var.prefix_payment_spring_boot}-container",
          "appProtocol": "http"
        }
      ], 
      "environment": [
        {
          "name": "CONTAINER_PORT",
          "value": "${var.payment_sb_port}"
        },
        {
          "name": "DB_HOST",
          "value": "${aws_db_instance.payment_db.address}"
        },
        {
          "name": "DB_PORT",
          "value": "${aws_db_instance.payment_db.port}"
        },
        {
          "name": "DB_NAME",
          "value": "${var.payment_db_identifier}"
        },
        {
          "name": "DB_USERNAME",
          "value": "${aws_db_instance.payment_db.username}"
        },
        {
          "name": "DB_PASSWORD",
          "value": "${aws_db_instance.payment_db.password}"
        },
        {
          "name": "REDIS_HOST",
          "value": "${aws_elasticache_cluster.payment_redis_db.cache_nodes[0].address}"
        },
        {
          "name": "REDIS_PORT",
          "value": "${aws_elasticache_cluster.payment_redis_db.cache_nodes[0].port}"
        },
        {
          "name": "SHED_LOCK_PENDING_PAYMENT",
          "value": "${var.SHED_LOCK_PENDING_PAYMENT}"
        },
        {
          "name": "LOG_ROOT_LEVEL",
          "value": "${var.LOG_ROOT_LEVEL}"
        },
        {
          "name": "LOG_APP_LEVEL",
          "value": "${var.LOG_APP_LEVEL}"
        },
        {
          "name": "CB_FAILURE_THRESHOLD",
          "value": "${var.CB_FAILURE_THRESHOLD}"
        },
        {
          "name": "CB_FAILURE_MIN_NO_CALL",
          "value": "${var.CB_FAILURE_MIN_NO_CALL}"
        },
        {
          "name": "CB_FAILURE_PERMITTED_NO_CALLS_IN_HALF_OPEN_STATE",
          "value": "${var.CB_FAILURE_PERMITTED_NO_CALLS_IN_HALF_OPEN_STATE}"
        },
        {
          "name": "CB_FAILURE_SLIDING_WINDOW",
          "value": "${var.CB_FAILURE_SLIDING_WINDOW}"
        },
        {
          "name": "CB_FAILURE_WAIT_DURATION_IN_OPEN_STATE",
          "value": "${var.CB_FAILURE_WAIT_DURATION_IN_OPEN_STATE}"
        },
        {
          "name": "TOTAL_MODIFICATION_ALLOWED",
          "value": "${var.TOTAL_MODIFICATION_ALLOWED}"
        },
        {
          "name": "TOTAL_DAYS_TO_PROCESS_PAYMENT",
          "value": "${var.TOTAL_DAYS_TO_PROCESS_PAYMENT}"
        },
        {
          "name": "DEFAULT_CACHE_TTL",
          "value": "${var.DEFAULT_CACHE_TTL}"
        },
        {
          "name": "PAYMENT_CACHE_TTL",
          "value": "${var.PAYMENT_CACHE_TTL}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
}

# define Service
resource "aws_ecs_service" "payment_ecs_service" {
  name            = "${var.prefix_payment_spring_boot}-container"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.min_capacity
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = ["${aws_security_group.ecs_tasks_sg.id}"]
    subnets          = flatten(["${aws_subnet.private_subnet.*.id}"])
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.payment_service_target_group.id
    container_name   = "${var.prefix_payment_spring_boot}-container"
    container_port   = var.payment_sb_port
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.aexp_namespace.arn
    service {
      discovery_name = "${var.prefix_payment_spring_boot}-container"
      port_name      = "${var.prefix_payment_spring_boot}-container"
      client_alias {
        dns_name = "${var.prefix_payment_spring_boot}-container"
        port     = var.payment_sb_port
      }
    }
  }
  depends_on = [aws_lb_listener_rule.payment_listener, aws_db_instance.payment_db]
}
