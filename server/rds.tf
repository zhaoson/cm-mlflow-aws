# Create a password for access to RDS
resource "random_password" "master_password" {
    length  = var.password_length
    
    # Thows an error when non-alphanumeric characters are allowed 
    special = false 
}

# CREATE A SECURITY GROUP 
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

resource "aws_db_subnet_group" "cm_mlflow_subnet_group" {
    name       = "${var.name}-subnet-group"
    subnet_ids = aws_subnet.cm_mlflow_public.*.id 
}

# Manages AWS RDS Aurora cluster 
resource "aws_rds_cluster" "cm_mlflow_rds" {
    cluster_identifier      = "${var.name}-rds"

    engine                  = "aurora-postgresql"
    # Don't need to specify engine_version 
    engine_mode             = "serverless"

    port                    = var.db_port
    database_name           = "mlflowdb"
    master_username         = "${var.username}"
    master_password         = random_password.master_password.result
    backup_retention_period = var.retention_period
    apply_immediately       = true
    deletion_protection     = false
    vpc_security_group_ids  = [aws_security_group.cm_mlflow_security.id]
    db_subnet_group_name    = aws_db_subnet_group.cm_mlflow_subnet_group.name 

    # Need this to delete properly
    skip_final_snapshot     = true

    scaling_configuration {
        auto_pause               = true 
        max_capacity             = 16
        min_capacity             = 2
        seconds_until_auto_pause = 300
        timeout_action           = "RollbackCapacityChange"
    }

    tags = {
        Name = "${var.name}-rds"
    }
}