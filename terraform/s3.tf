##################################
# S3 Bucket Artifacts
##################################

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket = "${var.app_name}-artifacts-${random_id.bucket_suffix.hex}"
}

