output "cm_app_url" {
    value = "https://${aws_apprunner_service.cm_mlflow_app.service_url}"
}

output "cm_mlflow_username" {
    value = var.mlflow_username
}

output "cm_mlflow_password" {
    value = var.mlflow_password

    # Necessary when outputting passwords
    sensitive = true 
}