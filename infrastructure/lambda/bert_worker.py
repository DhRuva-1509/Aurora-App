import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Basic SQS → Lambda receiver.
    Logs the message and returns success so SQS removes it.
    """

    logger.info("SQS event received:")
    logger.info(json.dumps(event, indent=2))

    try:
        for record in event.get("Records", []):
            body = record.get("body", "")
            logger.info(f"Raw SQS Body: {body}")

            # Attempt to parse JSON body
            try:
                parsed = json.loads(body)
                logger.info(f"Parsed message: {parsed}")
            except json.JSONDecodeError:
                logger.warning("Could not parse SQS body as JSON")

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Message processed"})
        }

    except Exception as e:
        logger.exception("Unhandled error in SQS worker")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
