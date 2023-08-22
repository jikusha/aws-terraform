resource "aws_sqs_queue" "demo-dlq" {
  name = "demo-dlq"
  delay_seconds = 0
  tags = {
    "Purpose" = "DLQ for lambda asynchronous"
  }
}


