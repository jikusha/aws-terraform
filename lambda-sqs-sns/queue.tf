resource "aws_sqs_queue" "demo-queue" {
  name = "demo-queue"
  delay_seconds = 0
  visibility_timeout_seconds = 3600
  tags = {
    "Purpose" = "DLQ for lambda asynchronous"
  }
}
