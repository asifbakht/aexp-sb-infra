
resource "aws_service_discovery_http_namespace" "aexp_namespace" {
  name = "${var.name_prefix}-namespace.local"
}

