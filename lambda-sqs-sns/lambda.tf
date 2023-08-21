// serverless
// serverless means the developers no need to manage the servers
// servers will be managed by AWS
// developers just need to provide the code (function) with some basic settings
// it doesn't mean that there are no servers. Just no need to manage the servers

// Serverless services
// Lambda, Glue, Step Functions, DynamoDB, SNS and SQS, Aurora serverless, S3 etc.

// AWS Lambda
// No need to manage servers
// Limited by time - maximum 15 mins
// Automatically scaled (RAM and CPU)
// Can be run on-demand

// pay per requests and compute time
// can be scaled upto 10GB RAM per function

// AWS Lambda Integration
// Can be integrated with S3, SNS, SQS, Eventbridge, CloudWatch Logs etc

// Synchronous invocation
// After invoking the lambda, it will wait for the result.
// e.g. when a lambda is invoked by a step-function, it is a sysnchronous invokation
// It will wait untill getting the result back from the lambda
// Other examples of synchronous invocation are: CLI, SDK etc
// in synchronous invokation, error handling must happen on client side


// Asynchronous invocation
// in this case, it will invoke the lambda but will not wait for the result.
// so this invocation is faster, as no need to wait for results. Trigger and forget.
// Services that can do asynchronous invocation:
// SNS, S3 event notifications, Cloundwatch Events/ Eventbridge etc
// The events are placed in an internal event queue
// From that event queue, events will trigger the lambda
// In case of failure, lambda will retry 3 times
// So in case of error, we will see duplicate log entries in cloundwatch logs
// We can define a DLQ for failed processing


resource "aws_lambda_function" "demo-lambda" {
  function_name = "demo-lambda"
  handler = "demo-lambda.handler"
  role = "arn:aws:iam::902932105105:role/service-role/DemoLambda-role-9okm6yyc"
  runtime = "python3.10"
  filename = "demo-lambda.zip"
  source_code_hash = filebase64sha256("demo-lambda.zip")
  timeout = 900
  dead_letter_config {
    target_arn = aws_sqs_queue.demo-dlq.arn
  }
  tags = {
    "Name" = "First Lambda using terraform",
    "Purpose" ="For Learning"
  }
  environment {
    variables = {
      ENV = "DEV"
    }
  }
}