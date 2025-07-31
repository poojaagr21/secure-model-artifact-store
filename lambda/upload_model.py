import boto3
import os

def lambda_handler(event, context):
    """
    Uploads a model file to the specified S3 bucket.
    This function assumes the file content is sent in the event as a string.
    """

    s3 = boto3.client('s3')
    bucket_name = os.environ.get('BUCKET_NAME')
    file_name = event.get('file_name')          # Example: 'model.pkl'
    file_content = event.get('file_content')    # Example: base64 or raw content

    if not bucket_name or not file_name or not file_content:
        return {
            "statusCode": 400,
            "message": "Missing one or more required fields: bucket_name, file_name, file_content"
        }

    try:
        # Upload model to S3
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)
        return {
            "statusCode": 200,
            "message": f"Model '{file_name}' uploaded successfully to '{bucket_name}'"
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "error": str(e)
        }
