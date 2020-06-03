## Create S3 Storage Bucket ##
resource "aws_s3_bucket" "bucket" {
  bucket = var.domain
  acl    = "public-read"
  policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_15_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "15s"
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "index.html"

  force_destroy = true
}
