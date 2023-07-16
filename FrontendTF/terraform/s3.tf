# create S3 Bucket:
resource "aws_s3_bucket" "bucket" {

  bucket_prefix = var.bucket_prefix #prefix appends with timestamp to make a unique identifier
  tags = {
    "Project"   = "lindalu.click"
    "ManagedBy" = "Terraform"
  }
  force_destroy = true
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# create bucket ACL :
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}



# block public access :
resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# create S3 website hosting:
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

# add bucket policy to let the CloudFront OAI get objects:
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy_document.json
}


# upload files to s3 bucket
# module "template_files" {
#   source = "hashicorp/dir/template"

#   base_dir = "../build"
# }

# resource "aws_s3_bucket_object" "static_files" {
#   for_each = module.template_files.files

#   bucket       = aws_s3_bucket.bucket.id
#   key          = each.key
#   content_type = each.value.content_type

#   # The template_files module guarantees that only one of these two attributes
#   # will be set for each file, depending on whether it is an in-memory template
#   # rendering result or a static file on disk.
#   source  = each.value.source_path
#   content = each.value.content

#   # Unless the bucket has encryption enabled, the ETag of each object is an
#   # MD5 hash of that object.
#   etag = each.value.digests.md5
# }


# data source to generate bucket policy to let OAI get objects:
data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

