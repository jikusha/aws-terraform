resource "aws_cloudwatch_event_rule" "invoke_lambda_rule" {
    name = "invoke_lambda_rule"
    description = "Cron Rule to Trigger lambda at a particular time"
    schedule_expression = "cron(07 18 ? * * *)"
    tags = {"Purpose" = "To trigger lambda at 11:30 PM IST"}
}


resource "aws_cloudwatch_event_target" "schedule_job_target" {
  arn = aws_lambda_function.demo-lambda.arn
  rule = aws_cloudwatch_event_rule.invoke_lambda_rule.id
  input = jsonencode({"Name": "Jiku_Sandilya"})
}

resource "aws_lambda_permission" "schedule_job_permission" { //lambda resource based policy
  statement_id = "AllowExecutionFromEventBridgeCron"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo-lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.invoke_lambda_rule.arn
}

resource "aws_s3_bucket_notification" "s3_event" {
  bucket = "jiku-demo-s3"  
  lambda_function {
    lambda_function_arn = aws_lambda_function.demo-lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "permission_for_s3_event_notification" { //lambda resource based policy
  statement_id = "AllowExecutionFromS3Event"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo-lambda.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::jiku-demo-s3"
}