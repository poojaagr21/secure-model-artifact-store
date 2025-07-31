import boto3
import os

def lambda_handler(event, context):
    """
    Downloads a model file from the specified S3 bucket.
    """

    s3 = boto3.client('s3')
    bucket_name = os.environ.get('BUCKET_NAME')
    file_name = event.get('file_name')          # Example: 'model.pkl'

    if not bucket_name or not file_name:
        return {
            "statusCode": 400,
            "message": "Missing required fields: bucket_name, file_name"
        }

    try:
        response = s3.get_object(Bucket=bucket_name, Key=file_name)
        file_content = response['Body'].read().decode('utf-8')

        return {
            "statusCode": 200,
            "file_name": file_name,
            "content": file_content
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "error": str(e)
        }
