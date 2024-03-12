# define Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name = var.payment_log_group_name

}

# define Log stream
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = var.payment_log_stream_name
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
