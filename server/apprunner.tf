# Creates the App Runner service for the MLFlow app
resource "aws_apprunner_service" "cm_mlflow_app" {
    service_name = "${var.name}-app"

    source_configuration {
        auto_deployments_enabled = false 

        image_repository {
            image_identifier      = "public.ecr.aws/t9j8s4z8/mlflow:latest"
            image_repository_type = "ECR_PUBLIC"

            image_configuration {
                port = var.mlflow_port 
                runtime_environment_variables = {
                    "MLFLOW_ARTIFACT_URI"               = "s3://${aws_s3_bucket.cm_mlflow_bucket.id}"
                    "MLFLOW_DB_DIALECT"                 = "postgresql"
                    "MLFLOW_DB_USERNAME"                = "${aws_rds_cluster.cm_mlflow_rds.master_username}"
                    "MLFLOW_DB_PASSWORD"                = "${random_password.master_password.result}"
                    "MLFLOW_DB_HOST"                    = "${aws_rds_cluster.cm_mlflow_rds.endpoint}"
                    "MLFLOW_DB_PORT"                    = "${aws_rds_cluster.cm_mlflow_rds.port}"
                    "MLFLOW_DB_DATABASE"                = "${aws_rds_cluster.cm_mlflow_rds.database_name}"
                    "MLFLOW_TRACKING_USERNAME"          = "mlflow-test"
                    "MLFLOW_TRACKING_PASSWORD"          = "mlflow-test-pw"
                    "MLFLOW_SQLALCHEMYSTORE_POOL_CLASS" = "NullPool"                   
                }
            }
        }
    }

    instance_configuration {
        cpu               = 1024
        memory            = 2048
        instance_role_arn = aws_iam_role.cm_mlflow_app_iam.arn
    }

    network_configuration {
        egress_configuration {
            egress_type       = "VPC"
            vpc_connector_arn = aws_apprunner_vpc_connector.cm_mlflow_vpc_connector.arn
        }
    }

    health_check_configuration {
        healthy_threshold   = 1
        interval            = 5
        unhealthy_threshold = 2
        timeout             = 2
        protocol            = "TCP"
    }

    tags = {
        Name = "${var.name}-app"
    }
}

resource "aws_apprunner_vpc_connector" "cm_mlflow_vpc_connector" {
    vpc_connector_name = "${var.name}-vpc-connector"
    subnets            = aws_subnet.cm_mlflow_public.*.id 
    security_groups    = [aws_security_group.cm_mlflow_security.id]
}

resource "aws_iam_role" "cm_mlflow_app_iam" {
    name = "${var.name}-app-iam"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"

                Principal = {
                    Service = "build.apprunner.amazonaws.com"
                }
            },
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"

                Principal = {
                    Service = "tasks.apprunner.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = "${var.name}-app-iam"
    }
}

resource "aws_iam_role_policy" "cm_mlflow_s3" {
    name = "${var.name}-s3"
    role = aws_iam_role.cm_mlflow_app_iam.id 

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action   = ["s3:ListBucket"]
                Effect   = "Allow"
                Resource = ["arn:aws:s3:::${aws_s3_bucket.cm_mlflow_bucket.bucket}"]
            },
            {
                Action   = ["s3:*Object"]
                Effect   = "Allow"
                Resource = ["arn:aws:s3:::${aws_s3_bucket.cm_mlflow_bucket.bucket}/*"]
            }
        ]
    })
}