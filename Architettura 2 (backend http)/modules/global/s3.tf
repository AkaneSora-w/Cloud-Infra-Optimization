resource "aws_s3_bucket" "cf_bucket" {
  bucket = "prova-bucket-cloudfront-default"
}

resource "aws_s3_object" "obj_index" {
  bucket = aws_s3_bucket.cf_bucket.bucket
  key = "index.html"
  acl = "public-read"
  content = "<html><body><h1>Hello, World!</h1></body></html>"
  content_type = "text/html"
}

resource "aws_s3_object" "obj_error" {
  bucket = aws_s3_bucket.cf_bucket.bucket
  key = "error.html"
  acl = "public-read"
  content = "<html><body><h1>Error, World!</h1></body></html>"
  content_type = "text/html"
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.cf_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  bucket = aws_s3_bucket.cf_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.bucket_pab]
  bucket = aws_s3_bucket.cf_bucket.id
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3_web_conf" {
  bucket = aws_s3_bucket.cf_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.cf_bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::prova-bucket-cloudfront-default/*"
        }
    ]
})
}
