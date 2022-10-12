import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, lambda_context):

    SENDER = "Sender Name <pim@technative.nl>"
    RECIPIENT = "pim@technative.nl"
    AWS_REGION = "eu-central-1"
    SUBJECT = "Amazon SES Test (SDK for Python)"
    BODY_TEXT = ("Amazon SES Test (Python)\r\n"
                 "This email was sent with Amazon SES using the "
                 "AWS SDK for Python (Boto)."
                )

    # The HTML body of the email.
    BODY_HTML = """
    <html>
    <head></head>
    <body>
      <h1>Amazon SES Test (SDK for Python)</h1>
      <p>This email was sent with
        <a href='https://aws.amazon.com/ses/'>Amazon SES</a> using the
        <a href='https://aws.amazon.com/sdk-for-python/'>
          AWS SDK for Python (Boto)</a>.</p>
    </body>
    </html>
    """

    # The character encoding for the email.
    CHARSET = "UTF-8"

    # Create a new SES resource and specify a region.
    client = boto3.client('ses',region_name=AWS_REGION)
    #client = boto3.client('ses')

    # Try to send the email.
    try:
        #Provide the contents of the email.
        response = client.send_email(
            Destination={
                'ToAddresses': [
                    RECIPIENT,
                ],
            },
            Message={
                'Body': {
                    'Html': {
                        'Charset': CHARSET,
                        'Data': BODY_HTML,
                    },
                    'Text': {
                        'Charset': CHARSET,
                        'Data': BODY_TEXT,
                    },
                },
                'Subject': {
                    'Charset': CHARSET,
                    'Data': SUBJECT,
                },
            },
            Source=SENDER,
            # If you are not using a configuration set, comment or delete the
            # following line
            #ConfigurationSetName=CONFIGURATION_SET,
        )
    except ClientError as e:
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "text/html"
                },
            "body": "<h1>FAIL</h1>" + e.response['Error']['Message']
            }

    else:
        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "text/html"
                },
            "body": "<h1>OK</h1>"
            }


## THIS BLOCK IS TOO RUN LAMBDA LOCALLY
if __name__ == '__main__':

    lambda_handler({}, {})
