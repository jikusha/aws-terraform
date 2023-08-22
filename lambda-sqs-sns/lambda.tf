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


// EventBridge Rule to trigger lambda
// We can set up CRON or Rate EventBridge Rule to trigger lambda in a particular time or after a given interval
// Need to create event_rule
// Need to create evemt_target
// Need to set up permission so that eventbridge can invoke the target (lambda resource based policy)


// S3 Event Notification to trigger Lambda
// when some object is being uploaded or removed from a S3 Bucket then we can set up S3 bucket to send event to a lambda and trigger it
// Asynchronous invocation


// Event Source Mapping
// In case of SQS trigger of a lambda, lambda need to poll message from the SQS
// If lambda doesn't poll, it will not be triggered
// For this purpose, an event source mapping will be created internally which will poll message from SQS and will trigger the lambda
// This is a synchronous invocation
// So basically:
// Event source mapper will poll SQS 
// We need to specify the batch size(1-10)
// We can't set up a DLQ for the lambda for error (as this is not a aysnchronous invocation)
// We need to set up DLQ for the SQS itself
// Lambda automatically scales up to process all the messages in the queue as quickly as possible
// Lambda deletes items from the queue after successful processing


// Lambda Destinations
// Lambda Destinations can be set up to send successful and failed events for asynchronous invocation
// Also can be set for discarded events for event source mapper


// Lambda IAM Role
// Lambda role gives the permission to lambda to use or invoke other services
// when we create event source mapper, then lambda role gives the access to read SQS event data


// Lambda Resource Based Policy
// It allows other services or other accounts to use lambda resources.
// If services like S3 need to access lambda, then resource based policy gives them the access

// An IAM Principal can access Lambda:
// If The Role attached to the principal allows it
// Or if the Lambda resouce based policy authorize it


// Lambda can write the logs to CloudWatch
// For this Lambda should have the permission to write into CloudWatch
// We need to specify in the lambda rule (this comes under LambdaBasicExecutionRole)

// Lambda has default RAM of 128 MB which can be increased upto 10 GB in 1MB increments (automated)
// The more RAM added, the more vCPU we get
// Any kind of DB connections or reusable thing is advisable to initialize outside the handler
// In this way, that part can be reused across invocation


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
    "Purpose" = "For Learning"
  }
  environment {
    variables = {
      ENV = "DEV"
    }
  }
}