# Create a basic S3 bucket
resource "aws_s3_bucket" "basic_bucket" {
  bucket = "lambda-artifacts"

  tags = {
    Name        = "My Basic S3 Bucket"
    Environment = "Development"
  }
}

# Output the bucket name
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.basic_bucket.id
}

# Output the bucket ARN
output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.basic_bucket.arn
}