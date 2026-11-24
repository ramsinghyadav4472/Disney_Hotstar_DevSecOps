terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Provider
# ---------------------------------------------------------------------------
# Uses AWS CLI credentials from ~/.aws/credentials automatically
provider "aws" {
  region = var.region
}

# ---------------------------------------------------------------------------
# Security Group: Ansible Control Node
# Only SSH allowed in
# ---------------------------------------------------------------------------
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-control-node-sg"
  description = "Allow SSH access to Ansible Control Node"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-control-node-sg"
  }
}

# ---------------------------------------------------------------------------
# Security Group: DevSecOps Target Node
# SSH + Jenkins (8080) + SonarQube (9000) + Grafana (3000) + Prometheus (9090)
# ---------------------------------------------------------------------------
resource "aws_security_group" "devsecops_sg" {
  name        = "devsecops-target-node-sg"
  description = "Allow SSH and DevSecOps service ports"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-target-node-sg"
  }
}

# ---------------------------------------------------------------------------
# EC2 Instance #1: Ansible Control Node (t2.micro — only runs Ansible)
# ---------------------------------------------------------------------------
resource "aws_instance" "ansible_control_node" {
  ami             = var.ami_id
  instance_type   = "t3.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.ansible_sg.name]

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Ansible-Control-Node"
    Role = "ansible"
  }
}

# ---------------------------------------------------------------------------
# EC2 Instance #2: DevSecOps Target Node (t2.large — Jenkins, Docker, SonarQube etc.)
# ---------------------------------------------------------------------------
resource "aws_instance" "devsecops_target_node" {
  ami             = var.ami_id
  instance_type   = "t3.small"
  key_name        = var.key_name
  security_groups = [aws_security_group.devsecops_sg.name]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "DevSecOps-Target-Node"
    Role = "devsecops"
  }
}
