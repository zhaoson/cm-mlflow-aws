# Create a password for access to RDS
resource "random_password" "master_password" {
    length  = var.password_length
    
    # Thows an error when non-alphanumeric characters are allowed 
    special = false 
}

# Create security group for association between RDS and App Runner
resource "aws_security_group" "cm_mlflow_security" {
    name        = "${var.name}-security"
    description = "Allows access to RDS via Postgres port"
    vpc_id      = aws_vpc.cm_mlflow_vpc.id 

    # Incoming traffic 
    ingress {
        from_port   = var.db_port
        to_port     = var.db_port
        protocol    = "tcp"

        cidr_blocks = [aws_vpc.cm_mlflow_vpc.cidr_block]
    } 

    # Outgoing traffic 
    egress {
        from_port   = 0
        to_port     = 0

        # Equivalent to "all"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-security-group"
    }
}

# Create DB subnet group for DB instances in the VPC
resource "aws_db_subnet_group" "cm_mlflow_subnet_group" {
    name       = "${var.name}-subnet-group"
    subnet_ids = aws_subnet.cm_mlflow_public.*.id 
}

# Manages AWS RDS Aurora cluster 
resource "aws_rds_cluster" "cm_mlflow_rds" {
    cluster_identifier      = "${var.name}-rds"

    engine                  = "aurora-${var.sql_engine}"
    # Don't need to specify engine_version 
    engine_mode             = "serverless"

    port                    = var.db_port
    database_name           = "mlflowdb"
    master_username         = "${var.username}"
    master_password         = random_password.master_password.result
    backup_retention_period = var.retention_period
    vpc_security_group_ids  = [aws_security_group.cm_mlflow_security.id]
    db_subnet_group_name    = aws_db_subnet_group.cm_mlflow_subnet_group.name 
    apply_immediately       = var.rds_apply_immediately
    deletion_protection     = var.rds_deletion_protection

    # Need this to delete properly
    skip_final_snapshot     = var.rds_skip_final_snapshot


    scaling_configuration {
        auto_pause               = var.rds_auto_pause
        max_capacity             = var.rds_max_capacity
        min_capacity             = var.rds_min_capacity
        seconds_until_auto_pause = var.rds_seconds_until_auto_pause
        timeout_action           = var.rds_timeout_action
    }

    tags = {
        Name = "${var.name}-rds"
    }
}