variable "operation" {
  type        = string
  description = "Operation to perform: 'create' or 'destroy'"
  validation {
    condition     = var.operation == "create" || var.operation == "destroy"
    error_message = "The operation value must be either 'create' or 'destroy'."
  }
}

locals {
  create_infra = var.operation == "create"
}

# VPC resource
resource "aws_vpc" "main" {
  count                = local.create_infra ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    local.default_tags,
    {
      Name = "main-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count  = local.create_infra ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags = merge(
    local.default_tags,
    {
      Name = "main-igw"
    }
  )
}

# Subnets
resource "aws_subnet" "public_1" {
  count                   = local.create_infra ? 1 : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = merge(
    local.default_tags,
    {
      Name = "Public Subnet"
    }
  )
}

resource "aws_subnet" "private_1" {
  count             = local.create_infra ? 1 : 0
  vpc_id            = aws_vpc.main[0].id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-central-1a"
  tags = merge(
    local.default_tags,
    {
      Name = "Private Subnet"
    }
  )
}

# Route Tables
resource "aws_route_table" "public" {
  count  = local.create_infra ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }
  tags = merge(
    local.default_tags,
    {
      Name = "Public Route Table"
    }
  )
}

resource "aws_route_table" "private_1" {
  count  = local.create_infra ? 1 : 0
  vpc_id = aws_vpc.main[0].id
  tags = merge(
    local.default_tags,
    {
      Name = "Private Route Table"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
  count          = local.create_infra ? 1 : 0
  subnet_id      = aws_subnet.public_1[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private_1" {
  count          = local.create_infra ? 1 : 0
  subnet_id      = aws_subnet.private_1[0].id
  route_table_id = aws_route_table.private_1[0].id
}

# Security Group
resource "aws_security_group" "allow_internal" {
  count       = local.create_infra ? 1 : 0
  name        = "allow_internal"
  description = "Allow all internal VPC traffic"
  vpc_id      = aws_vpc.main[0].id

  ingress {
    description = "All traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main[0].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    {
      Name = "allow_internal"
    }
  )
}

# VPC Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  count             = local.create_infra ? 1 : 0
  vpc_id            = aws_vpc.main[0].id
  service_name      = "com.amazonaws.eu-central-1.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.public[0].id,
    aws_route_table.private_1[0].id
  ]
  tags = merge(
    local.default_tags,
    {
      Name = "DynamoDB VPC Endpoint"
    }
  )
}