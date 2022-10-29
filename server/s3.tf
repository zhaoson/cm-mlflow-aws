# Creates an s3 bucket
resource "aws_s3_bucket" "cm_mlflow" {
    bucket = "${var.name}-${var.env}"

    force_destroy = true
    tags = {
        Name        = "${var.name}-s3"
        Environment = "${var.env}"
    }
}

# Allows objects in bucket to be versioned 
resource "aws_s3_bucket_versioning" "cm_mlflow" {
    bucket = aws_s3_bucket.cm_mlflow.id 
    
    versioning_configuration {
        status = "Enabled"
    }
}

# Blocks all public access to the bucket 
resource "aws_s3_bucket_public_access_block" "cm_mlflow" {
    bucket = aws_s3_bucket.cm_mlflow.id 

    block_public_acls = true 
    block_public_policy = true 
    ignore_public_acls = true 
    restrict_public_buckets = true 
}