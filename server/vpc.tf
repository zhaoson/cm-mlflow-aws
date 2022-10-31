# Create a VPC resource for AWS 
resource "aws_vpc" "cm_mlflow_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true 

    tags = {
        Name = "${var.name}-vpc"
    }
}

# Create public VPC subnet resources 
resource "aws_subnet" "cm_mlflow_public" {
    count                   = var.num_public_subnets
    vpc_id                  = aws_vpc.cm_mlflow_vpc.id 
    cidr_block              = "10.0.${count.index + 2}.0/24"
    availability_zone       = data.aws_availability_zones.available.names[count.index]

    # Indicates that this is a public subnet
    map_public_ip_on_launch = true 

    tags = {
        Name = "${var.name}-public-subnet-${count.index}"
    }
}

#  Create VPC Internet Gateway 
resource "aws_internet_gateway" "cm_mlflow_internet" {
    vpc_id = aws_vpc.cm_mlflow_vpc.id

    tags = {
        Name = "${var.name}-internet-gateway"
    }
}

# Create VPC Route Table 
resource "aws_route_table" "cm_mlflow_route_table" {
    vpc_id = aws_vpc.cm_mlflow_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cm_mlflow_internet.id
    }

    tags = {
        Name = "${var.name}-route-table"
    }
}

# Create association between route table and public subnets 
resource "aws_route_table_association" "cm_mlflow_rt_public" {
    count          = var.num_public_subnets
    route_table_id = aws_route_table.cm_mlflow_route_table.id 
    subnet_id      = aws_subnet.cm_mlflow_public.*.id[count.index]
}