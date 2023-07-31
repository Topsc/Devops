resource "aws_s3_bucket" "backend_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::783225319266:root"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "backend_env_bucket" {
  bucket = var.bucket_env_name
  acl    = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.backend_env_bucket.id
  key    = "config/.env"
  source = "~/.env" # replace this with your .env file path
}