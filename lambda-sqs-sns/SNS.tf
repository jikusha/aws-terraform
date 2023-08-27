// SNS
// Simple Notification Service => pub/sub model
// Need to create a SNS topic
// Need to create subscribers for the topic
// When we will publish message to the Topic, then all the subscribers will receive the message
// 12, 500, 000 subscription limit
// 100, 000 topic limit
// We can create SQS, Lambda as subscribers of SNS Topic
// We can publish message to SNS topic using SDK, lambda, S3 event notification, Cloudwatch Alarms etc
// So the publisher no need to send the message to each subscriber one by one
// It needs to publish once to the SNS topic, and all subscribers will receive the message

// At rest encryption using KMS
// there are IAM policies to regulate access to SNS
// Also there is SNS access policy, with the help of which we can grant access to cross account or other AWS services


// SNS + SQS: Fan Out Pattern
// Instead of directly subscribing to the (tight couple) to the SNS topic, if we use a SQS queue to decouple the application and 
// the SNS topic (loose couple)
// We can use the benifits of SQS(persistence, delayed processing, retry etc)
// lets say we have a lambda which needs to be triggered when a message comes in the SNS topic
// So we can create a SQS queue as subscriber of the topic
// then we can trigger the lambda using SQS event source mapper


resource "aws_sns_topic" "demo-topic" {
  name = "demo-topic"
}

resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.demo-topic.arn
  policy = <<POLICY
{
  "Id": "Policy1692992839286",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1692992831323",
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Effect": "Allow",
      "Resource": "${aws_sns_topic.demo-topic.arn}",
      "Principal": "*"
    },
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::902932105105:root"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "${aws_sns_topic.demo-topic.arn}"
    }
  ]
}
POLICY
}