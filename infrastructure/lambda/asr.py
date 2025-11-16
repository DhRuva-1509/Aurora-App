import json
import os
import boto3

sqs = boto3.client("sqs")

# Loaded from Terraform via environment variables
SQS_URL = os.environ.get("SQS_URL")


def lambda_handler(event, context):
    print("Incoming API Gateway event:", json.dumps(event))

    # Parse request body
    try:
        body = json.loads(event.get("body", "{}"))
    except Exception:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Invalid JSON"})
        }

    text = body.get("text")

    if not text:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing 'text' field"})
        }

    # Send message to SQS
    try:
        sqs.send_message(
            QueueUrl=SQS_URL,
            MessageBody=json.dumps({"text": text})
        )

        print(f"Sent to SQS: {text}")

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Queued successfully"})
        }

    except Exception as e:
        print("Error sending to SQS:", e)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
