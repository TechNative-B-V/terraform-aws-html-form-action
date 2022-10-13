import boto3
from botocore.exceptions import ClientError
import json
import os
import urllib.parse

def field_value(field_dict, key, default):
    if key in field_dict:
        return field_dict[key][0]
    else:
        return default

def form_mail_body(field_dict):
    html = ""
    for key, value in field_dict.items():
        if key[0] == "_":
            continue

        html += "<p><strong>"+key+":</strong><br>"
        html += value[0]+"</p>"

    return html

def lambda_handler(event, lambda_context):

    #slack_webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
    #lambda_conf = json.loads(os.environ.get('LAMBDA_CONF'))
    #sts_master_account_role_arn = os.environ.get('STS_MASTER_ACCOUNT_ROLE_ARN')
    #default_threshold = os.environ.get('DEFAULT_THRESHOLD')

    mail_charset = "UTF-8"
    AWS_REGION   = "eu-central-1" # TODO ENVVAR

    queryStr = event["body"]
    fields = urllib.parse.parse_qs(queryStr)
    success_url = field_value(fields, "_success_url", "")
    field_html = form_mail_body(fields)

    mail_body = f" <html> <head></head> <body> <h1>Form data</h1>{field_html} </body> </html> "

    return_body="""
<html>
<head>
</head>
<body>
Form has been submitted.
</body>
</html>
"""

    if(success_url != ""):
        return_body=f"<html><head><meta http-equiv=\"Refresh\" content=\"0; URL={success_url}\" /></head><body></body></html>"

    client = boto3.client('ses',region_name=AWS_REGION)
    #client = boto3.client('ses')
    try:
        to_address = field_value(fields, "_to", os.environ.get('TO_MAIL'))
        from_address = field_value(fields, "_from", os.environ.get('FROM_MAIL'))

        response = client.send_email(
            Destination={
                'ToAddresses': [
                    to_address,
                ],
            },
            Message={
                'Body': {
                    'Html': {
                        'Charset': mail_charset,
                        'Data': mail_body,
                    },
                },
                'Subject': {
                    'Charset': mail_charset,
                    'Data': field_value(fields,"_subject", "Form Submission"),
                },
            },
            Source=from_address,
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
            "body": return_body
            #"body": json.dumps(event)
            }


## THIS BLOCK IS TOO RUN LAMBDA LOCALLY
if __name__ == '__main__':
    mock_event = {
            "body": "_subject=Demo+Form+Submission&_to=pim%40technative.nl&_from=pim%40technative.nl&_success_url=http%3A%2F%2Flocalhost%3A8000%2Fform_success.html&_fail_url=http%3A%2F%2Flocalhost%3A8000%2Fform.html&full-name=test&Email=test&message=test"
            }

    lambda_handler(mock_event, {})
