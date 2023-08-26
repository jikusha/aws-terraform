// Messaging Services
// When we have multiple applications deployed, then these applications need to communicate between themselves
// Communication can be in the following way:
// Direct communication between application to application => Tight coupled => not recommended for suddent spike
// Event based communication => using SQS(queue) and SNS(Pub-sub model) => loose coupled
// SQS + SNS


// SQS - Standard queue
// SQS is fully managed queue(messaging service) offered by AWS
// used to decouple application (EDP and EMOS)
// producer send messages to SQS
// consumer poll messages from SQS
// It can have unlimited no of messages in the queue
// Default retention period => 4 days
// Max retention period => 14 days
// Limitaion of a message => 256KB


// Producer
// using SNS we can send messaged to SQS
// the message is persisted in the queue untill consumer deletes it

// Consumer
// can be lambda, ec2 or on-prem application
// consumer poll SQS for messages (it can receive upto 10 messages at a time)
// The consumer needs to delete the message from SQS after successfully processing it

// SQS queue access policy
// It is required to give access to cross acount or to give accesss to other services to send or poll messages from SQS
// Alternatively, if a service has a role which allows the SQS access, then also it will be able to send or receive messages from SQS

// Visibility Timeout
// When a consumer polls a messages, then the message will become invisible for other consumers
// Due to this visibility timeout
// If the consumer won' be able to process and delete the message within the visibility timeout,
// then the message will be again returned to the queue (we may get duplicate processing)
// So we need to set the visibility timeout by considering all these factors


resource "aws_sqs_queue" "demo-queue" {
  name = "demo-queue"
  delay_seconds = 0
  visibility_timeout_seconds = 3600
  tags = {
    "Purpose" = "DLQ for lambda asynchronous"
  }
}


resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.demo-queue.id
  policy = <<POLICY
{
  "Id": "Policy1692992839286",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1692992831323",
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:SendMessage"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:sqs:ap-south-1:902932105105:demo-queue",
      "Principal": "*"
    },
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::902932105105:root"
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:ap-south-1:902932105105:demo-queue"
    }
  ]
}
POLICY
}