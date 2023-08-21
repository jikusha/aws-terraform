# export AWS_ACCESS_KEY_ID=AKIA5EOXSQ6IRGPZC4ET
# export AWS_SECRET_ACCESS_KEY=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


import boto3, json

# client = boto3.client('stepfunctions',
#                       aws_access_key_id='AKIA5EOXSQ6IRGPZC4ET', 
#                       aws_secret_access_key='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')

# event = json.dumps({
#     'wait_needed': True,
#     'wait_seconds': 5,
#     'error': False,
#     'exception': False
# })

# client.start_execution(
#     stateMachineArn = 'arn:aws:states:ap-south-1:902932105105:stateMachine:First-Step-Function',
#     input = event
# )

lambda_client = boto3.client('lambda',
                      aws_access_key_id='AKIA5EOXSQ6IRGPZC4ET', 
                      aws_secret_access_key='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')

# synchronous invokation
res = lambda_client.invoke(
    FunctionName = 'demo-lambda',
    InvocationType = 'Event', # asynchronous invocation
    Payload = json.dumps({"name": "Jiku"})
)

print(res)