provider "aws" {
  region = "us-east-1"
}

# Bucket-name

resource "aws_s3_bucket" "my_first_bucket_for_frontend" {
  bucket = "my-first-bucket-for-frontend"

# Enable static website hosting

website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "StaticWebsiteBucket"
    env = "dev"
  }
}

# Public access block

resource "aws_s3_bucket_public_access_block" "frontend_access" {
  bucket = aws_s3_bucket.my_first_bucket_for_frontend.id
}

# Bucket Policy

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_first_bucket_for_frontend.id
  # policy = data.aws_iam_policy_document.allow_access_from_another_account.json

   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.my_first_bucket_for_frontend.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.frontend_access]
}

# Get endpoint

output "website_endpoint" {
  value       = aws_s3_bucket.my_first_bucket_for_frontend.website_endpoint
  description = "The URL to access the static website"
}




