#!/bin/bash

cd ./server

# Prompt user for AWS credentials
echo "Please enter your AWS access key id:"
read access_key_id
echo "Please enter your AWS secret access key:"
read secret_access_key

export AWS_ACCESS_KEY_ID=${access_key_id}
export AWS_SECRET_ACCESS_KEY=${secret_access_key}

# Initializing Terraform
terraform init

# Prompt user for username and password for authentication to website 
echo "Please enter a username (you will use this to access the MLFlow UI):"
read username
echo "Please enter a password (you will use this to access the MLFlow UI):"
read password 

# Create resources to deploy to AWS
terraform apply -var mlflow_username=${username} -var mlflow_password=${password}