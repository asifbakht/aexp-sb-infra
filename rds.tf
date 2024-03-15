resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "payment_db" {
  identifier             = var.payment_db_identifier
  allocated_storage      = 20
  engine                 = var.payment_db_engine
  engine_version         = var.payment_db_engine_version
  instance_class         = var.payment_db_cpu_class
  username               = var.payment_db_user_name
  password               = random_password.password.result
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_access_sg.id]
  skip_final_snapshot    = true
  multi_az               = true
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.name_prefix}-elasticache-subnet-group"
  subnet_ids = flatten(["${aws_subnet.private_subnet.*.id}"])
}


resource "aws_elasticache_cluster" "payment_redis_db" {
  cluster_id           = var.payment_db_identifier
  engine               = var.payment_redis_engine
  engine_version       = var.payment_redis_engine_version
  node_type            = var.payment_redis_node_type
  num_cache_nodes      = var.payment_redis_num_cache_nodes
  parameter_group_name = var.payment_redis_parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_access_sg.id]
  apply_immediately    = true
}
