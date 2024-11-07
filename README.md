This Terraform configuration sets up a basic AWS infrastructure in the us-east-1 region using the DevOpsAdmin profile. It includes:

VPC Creation (aws_vpc.vpc01): Defines a Virtual Private Cloud (VPC) with a CIDR block of 172.30.0.0/16.

Subnet (aws_subnet.public_subnet01): Creates a public subnet within the VPC with a CIDR block of 172.30.1.0/24.

Internet Gateway (aws_internet_gateway.igw01): Adds an internet gateway to the VPC to enable external internet access.

Route Table and Association (aws_route_table.rtb_Public): Sets up a route table for internet-bound traffic (CIDR 0.0.0.0/0) via the internet gateway and associates it with the public subnet.

Security Group (aws_security_group.internet): Defines a security group for the VPC, with:

Ingress Rule (aws_vpc_security_group_ingress_rule.AllowICMPV4): Allows ICMP traffic within the VPC.
Egress Rule (aws_vpc_security_group_egress_rule.AllowAll): Allows all outbound traffic.
EC2 Instance (aws_instance.App-ec2): Launches an Amazon EC2 instance in the public subnet with a public IP, secured by the internet security group, and configured with the t2.micro instance type and specified AMI.

Outputs: Displays the EC2 instance ID, private IP, public IP, and VPC ID after deployment.
