resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
  lifecycle_rule {
    id      = var.lifecycle_name
    enabled = true

    tags = {
      name = var.lifecycle_name
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
  tags = {
    "name" = "yyh.dev.domain.tld"
  }
}