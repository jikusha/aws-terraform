import boto3

sqs_client = boto3.client('sqs',
                      aws_access_key_id='AKIA5EOXSQ6IRGPZC4ET', 
                      aws_secret_access_key='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')


#res = sqs_client.send_message(MessageBody='{"Name":"Jiku"}', QueueUrl = 'https://sqs.ap-south-1.amazonaws.com/902932105105/demo-queue-1')

# print(res)

message = sqs_client.receive_message(QueueUrl = 'https://sqs.ap-south-1.amazonaws.com/902932105105/demo-queue-1')
print(message)
sqs_client.delete_message(QueueUrl = 'https://sqs.ap-south-1.amazonaws.com/902932105105/demo-queue-1', ReceiptHandle = message['Messages'][0]['ReceiptHandle'])