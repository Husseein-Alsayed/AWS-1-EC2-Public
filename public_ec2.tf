# Provider AWS
provider "aws" {
    region  = "us-east-1"
    profile = "DevOpsAdmin"   # This is my AWS Profile
}

# Create VPC
resource "aws_vpc" "vpc01" {
    cidr_block = "172.30.0.0/16"
    tags = {
        Name = "vpc01"
    }
}

# Create Subnet
resource "aws_subnet" "public_subnet01" {
    vpc_id     = aws_vpc.vpc01.id
    cidr_block = "172.30.1.0/24"
    tags = {
        Name = "public_subnet01"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw01" {
    vpc_id = aws_vpc.vpc01.id
    tags = {
        Name = "igw01"
    }
}

# Route Table
resource "aws_route_table" "rtb_Public" {
    vpc_id = aws_vpc.vpc01.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw01.id
    }

    tags = {
        Name = "rtb_public"
    }
}

# Associate the Subnet with the Route Table --------------------------------Important------------------------------
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet01.id  
    route_table_id = aws_route_table.rtb_Public.id
}

# Create Security Group
resource "aws_security_group" "internet" {
    vpc_id = aws_vpc.vpc01.id
    tags = {
        Name = "internet"
    }
}

# Security Group Ingress Rule for ICMP
resource "aws_vpc_security_group_ingress_rule" "AllowICMPV4" {
    security_group_id = aws_security_group.internet.id
    cidr_ipv4         = "0.0.0.0/0"   #--------------------------------Important------------------------------
    from_port         = -1
    to_port           = -1
    ip_protocol       = "icmp"
}

# Security Group Egress Rule to Allow All Outbound Traffic
resource "aws_vpc_security_group_egress_rule" "AllowAll" {
    security_group_id = aws_security_group.internet.id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1"  # Allows all protocols and ports
}

# Create EC2 Instance
resource "aws_instance" "App-ec2" {
    subnet_id                   = aws_subnet.public_subnet01.id
    ami                         = "ami-06b21ccaeff8cd686"      #you can replyce it with the ami for your ec2 on the reagion you want to create the EC2 on 
    vpc_security_group_ids      = [aws_security_group.internet.id]
    associate_public_ip_address = true
    instance_type               = "t2.micro"
    
    tags = {
        Name = "App-ec2"
    }
}
#-------------------------------------------------------------I was Just interested on the Public IP -------------------------------------------------
# Outputs
output "ec2-ID" {
    value = aws_instance.App-ec2.id
}

output "ec2-privateIP" {
    value = aws_instance.App-ec2.private_ip
}

output "ec2-PublicIP" {
    value = aws_instance.App-ec2.public_ip
}

output "VPC-ID" {
    value = aws_vpc.vpc01.id
}
