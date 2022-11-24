# resource "aws_s3_bucket" "s3_buckets" {
#   count         = length(var.s3_buckets)
#   bucket        = var.s3_buckets[count.index]
#   force_destroy = var.force_destroy
# }

# resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
#   count  = length(var.s3_buckets)
#   bucket = var.s3_buckets[count.index]
# #   rule {
# #     id      = "expire"
# #     prefix  = ""
# #     enabled = true
# #     expiration {
# #       days = lookup(var.s3_buckets[var.s3_buckets[count.index]], "expiration_days")
# #     }
# #   }
#   rule {
#     id     = "data_archive"
#     status = "Enabled"

#     # expiration {
#     #   days = 365
#     # }

#     transition {
#       days          = 120
#       storage_class = "GLACIER"
#     }
#   }

# }

# resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
#   count  = length(var.s3_buckets)
#   bucket = var.s3_buckets[count.index]
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#   count  = length(var.s3_buckets)
#   bucket = var.s3_buckets[count.index]
#   acl    = "private"
# }

# resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
#   count                   = length(var.s3_buckets)
#   bucket                  = var.s3_buckets[count.index]
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

resource "aws_s3_bucket_policy" "cloudfront_bucket_policy" {
  count  = length(var.s3_buckets)
  bucket = var.s3_buckets[count.index]
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AWSCloudFrontOriginAccessIdentity${aws_cloudfront_origin_access_identity.s3_origin_access_identity.id}",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_cloudfront_origin_access_identity.s3_origin_access_identity.iam_arn}"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.s3_buckets[count.index]}/*"
      }
    ]
  })
}
