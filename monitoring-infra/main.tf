provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  default_tags {
    tags = {
      name = "monitoring_metrics"
    }
  }
}

resource "aws_vpc" "monitoring_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "monitoring_vpc"
  }
}

resource "aws_subnet" "monitoring_subnet" {
  vpc_id            = aws_vpc.monitoring_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.eu_availability_zone

  tags = {
    Name = "monitoring_subnet"
  }
}

resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring_sg"
  description = "Security Group for prometheus instance"
  vpc_id      = aws_vpc.monitoring_vpc.id

  ingress {
    description = "Allow port 9090 inbound for Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 3000 inbound for Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 80 inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 443 inbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 22 inbound SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 9100 inbound for Mode_exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 9090 outbound"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 3000 outbound"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 80 outbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 443 outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 22 outbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow port 9100 outbound"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_internet_gateway" "monitoring_igw" {
  vpc_id = aws_vpc.monitoring_vpc.id
}

resource "aws_route" "monitoring_internet_route" {
  route_table_id         = aws_vpc.monitoring_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.monitoring_igw.id
}


resource "aws_iam_role" "monitoring_aws_iam_role" {
  name = "monitoring_aws_iam_role"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF
}

resource "aws_iam_instance_profile" "monitoring_iam_instance_profile" {
  name = "monitoring_iam_instance_profile"
  role = aws_iam_role.monitoring_aws_iam_role.name
}

resource "aws_iam_role_policy" "monitoring_iam_role_policy" {
  name = "monitoring_iam_role_policy"
  role = aws_iam_role.monitoring_aws_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ec2:Describe*",
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = "elasticloadbalancing:Describe*",
        Resource = "*",
      },
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:Describe*",
        ],
        Resource = "*",
      },
      {
        Effect   = "Allow",
        Action   = "autoscaling:Describe*",
        Resource = "*",
      },
    ],
  })
}


# Create EC2 Instance

resource "aws_instance" "monitoring_instance" {
  ami                         = var.ec2_ami_id
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  subnet_id                   = aws_subnet.monitoring_subnet.id
  iam_instance_profile        = aws_iam_instance_profile.monitoring_iam_instance_profile.name
  user_data                   = base64encode(file("./set_monitoring.sh"))
  tags = {
    "Name" = "monitoring_instance"
  }
}

