# Create a basic S3 bucket
resource "aws_s3_bucket" "artifact-bucket" {
  bucket = "rahul-kamble-personal-org-lambda-artifacts"

  tags = {
    Name        = "lambda-artifacts-1"
    Environment = "Development"
  }
}

# Output the bucket name
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.artifact-bucket.id
}

# Output the bucket ARN
output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.artifact-bucket.arn
}