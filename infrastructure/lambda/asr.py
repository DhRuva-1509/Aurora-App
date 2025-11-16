import json

def lambda_handler(event, context):
    # event["body"] is a string JSON
    body = json.loads(event["body"])

    text = body.get("text", "")

    print("Received ASR text:", text)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Text received successfully",
            "received_text": text
        })
    }
