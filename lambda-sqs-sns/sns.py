import boto3, json

sns_client = boto3.client('sns',
                      aws_access_key_id='AKIA5EOXSQ6IRGPZC4ET', 
                      aws_secret_access_key='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')


res = sns_client.publish(
    TopicArn = 'arn:aws:sns:ap-south-1:902932105105:demo-topic',
    Message = json.dumps({"Name":"Jiku_Sandilya"})
)