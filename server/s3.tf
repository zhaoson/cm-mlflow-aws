resource "aws_s3_bucket" "mlflow_artifact_bucket" {
    bucket = "cm-mlflow-bucket"

    force_destroy = true
    tags = {
        Name        = "artifact_bucket"
        Environment = "dev"
    }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
    bucket = aws_s3_bucket.mlflow_artifact_bucket.id
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.mlflow_artifact_bucket.id
    
    versioning_configuration {
        status = "Enabled"
    }
}

# Potentially add: Encrpytion (for security purposes)