variable "aws_region" {
    type        = string
    description = "The AWS region used to deploy the server"
    default     = "us-east-2"
}

variable "name" {
    type        = string
    description = "The naming convention used for AWS objects"
    default     = "cm-mlflow"
}

variable "db_port" {
    type        = number 
    description = "Port used to access database (Postgres)"
    default     = 5432
}

variable "username" {
    type        = string
    description = "Username to access AWS RDS"
    default     = "cmmlflow"
}

variable "num_public_subnets" {
    type        = number 
    description = "The number of public subnets to deploy"
    default     = 2
}

variable "password_length" {
    type        = number
    description = "The length of the password to be generated for access to AWS RDS"
    default     = 10
}

variable "retention_period" {
    type        = number
    description = "The number of days to retain backups"
    default     = 1
}

variable "mlflow_port" {
    type        = number 
    description = "The port used to access MLFlow"
    default     = 8080
}

variable "cm_mlflow_bucket_path" {
    type        = string
    description = "The path in the S3 bucket where S3 will store objects"
    default     = "/"
}

variable "rds_max_capacity" {
    type = number
    description = "The maximum capacity for the Aurora DB cluster"
    default = 16
}

variable "rds_min_capacity" {
    type = number
    description = "The minimum capacity for the Aurora DB cluster"
    default = 2
}

variable "rds_timeout_action" {
    type = string
    description = "Action to take when timeout is rached"
    default = "RollbackCapacityChange"
}

variable "rds_seconds_until_auto_pause" {
    type = number
    description = "The time, in seconds, before the Aurora DB cluster is paused"
    default = 300
}

variable "rds_auto_pause {
    type = bool
    description = "Whether or not automatic pause of the Aurora DB cluster is allowed"
    default = true 
}

variable "sql_engine" {
    type = string 
    description = "The SQL engine to be used for the RDS"
    default = "postgresql"
}

variable "app_cpu" {
    type = number 
    description = "The number of CPU units to reserve for each instance of the MLFlow app (1024: 1 vCPU, 2048: 2 vCPU, etc)"
    default = 1024
}

variable "app_memory" {
    type = number 
    description = "The amount of memory to reserve for each instance of the MLFlow app (2048: 2GB, 3072: 3GB, etc)"
    default = 2048
}

variable "app_healthy_threshold" {
    type = number
    description = "Number of successful consecutive checks needed to decide that the app is healthy"
    default = 1
}

variable "app_interval" {
    type = number 
    description = "Time, in seconds, between health checks"
    default = 5
}

variable "app_timeout" {
    type = number 
    description = "Time, in seconds, to wait for a health check response before deciding it failed"
    default = 5
}

variable "app_unhealthy_threshold" {
    type = number 
    description = "Number of consecutive failed checks needed to decide that the app is unhealthy"
    default = 2
}

variables "rds_skip_final_snapshot" {
    type = bool 
    description = "Determines whether or not a final snapshot of the DB should be created before the cluster is deleted"
    default = true 
}

variable "rds_apply_immediately" {
    type = bool
    description = "Determines whether or not cluster modifications are applied immediately or at the next maintenance window"
    default = true 
}

variable "rds_deletion_protection" {
    type = bool 
    description = "Determines whether or not the DB instance can be deleted"
    default = false
}

data "aws_availability_zones" "available" {}