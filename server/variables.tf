variable "aws_region" {
    type = string
    description = "The AWS region used to deploy the server"
    default = "us-east-2"
}

variable "name" {
    type = string
    description = "The naming convention used for AWS objects"
    default = "cm-mlflow"
}

variable "db_port" {
    type = number 
    description = "Port used to access database (Postgres)"
    default = 5432
}

variable "username" {
    type = string
    description = "Username to access AWS RDS"
    default = "cmmlflow"
}

variable "num_public_subnets" {
    type = number 
    description = "The number of public subnets to deploy"
    default = 2
}

variable "password_length" {
    type = number
    description = "The length of the password to be generated for access to AWS RDS"
    default = 10
}

variable "retention_period" {
    type = number
    description = "TODO"
    default = 1
}

variable "mlflow_port" {
    type = number 
    description = "The port used to access MLFlow"
    default = 8080
}

variable "cm_mlflow_bucket_path" {
    type = string
    description = "The path in the S3 bucket where S3 will store objects"
    default = "/"
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}