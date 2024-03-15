
variable "name_prefix" {
  default = "aexp"
}

variable "name_task" {
  default = "aexp-task"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "az_count" {
  default = "2"
}

variable "healthcheck_path" {
  default = "/"
}

variable "fargate_cpu" {
  default = "512"
}

variable "fargate_memory" {
  default = "1024"
}


variable "min_capacity" {
  default = "1"
}

variable "max_capacity" {
  default = "5"
}

variable "alb_protocol" {
  default = "HTTP"
}


variable "web_port" {
  default = "80"
}

variable "payment_sb_port" {
  default = "9999"
}

variable "payment_image" {
  default = "docker.io/asifbakht/payment-service:latest"
}

variable "DB_HOST" {
  default = "DB_HOST"
}

variable "DB_USERNAME" {
  default = "DB_USERNAME"
}

variable "DB_PORT" {
  default = "DB_PORT"
}


variable "DB_PASSWORD" {
  default = "DB_PASSWORD"
}

variable "prefix_payment_spring_boot" {
  default = "payment-sb"
}


variable "payment_log_group_name" {
  default = "/ecs/payment_service_task"
}

variable "payment_log_stream_name" {
  default = "ecs-log-stream"
}


variable "payment_db_identifier" {
  default = "payment-db"
}

variable "DB_NAME" {
  default = "payment-db"
}

variable "payment_db_engine" {
  default = "mysql"
}

variable "payment_db_engine_version" {
  default = "8.0.36"
}

variable "payment_db_cpu_class" {
  default = "db.t2.micro"
}

variable "payment_db_user_name" {
  default = "social_user"
}


variable "payment_db_port" {
  default = 3306
}

variable "payment_redis_engine" {
  default = "redis"
}

variable "payment_redis_engine_version" {
  default = "6.2"
}

variable "payment_redis_node_type" {
  default = "cache.t2.micro"
}

variable "payment_redis_num_cache_nodes" {
  default = 1
}


variable "payment_redis_parameter_group_name" {
  default = "default.redis6.x"
}

variable "REDIS_HOST" {
  default = "REDIS_HOST"
}

variable "REDIS_PORT" {
  default = "REDIS_PORT"
}

variable "SHED_LOCK_PENDING_PAYMENT" {
  default = "*/10 * * * * *"
}

variable "LOG_ROOT_LEVEL" {
  default = "INFO"
}

variable "LOG_APP_LEVEL" {
  default = "DEBUG"
}

variable "CB_FAILURE_THRESHOLD" {
  default = 25
}

variable "CB_FAILURE_MIN_NO_CALL" {
  default = 10
}

variable "CB_FAILURE_PERMITTED_NO_CALLS_IN_HALF_OPEN_STATE" {
  default = 10
}

variable "CB_FAILURE_SLIDING_WINDOW" {
  default = 55
}

variable "CB_FAILURE_WAIT_DURATION_IN_OPEN_STATE" {
  default = "10s"
}

variable "TOTAL_MODIFICATION_ALLOWED" {
  default = 5
}

variable "TOTAL_DAYS_TO_PROCESS_PAYMENT" {
  default = 2
}

variable "DEFAULT_CACHE_TTL" {
  default = 5
}

variable "PAYMENT_CACHE_TTL" {
  default = 10
}
