variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}


variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}



variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}


variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 CIDR"
  type        = string
  default     = "10.0.4.0/24"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}


variable "app_name" {
  description = "Application name"
  type        = string
  default     = "nginx-app"
}

variable "codestar_connection_arn" {
  description = "CodeStar Connection ARN. Leave empty to use the Terraform-created GitHub connection."
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository (charltonmc2024/aws-terraform-beanstalk-cicd)"
  type        = string
  default     = "charltonmc2024/aws-terraform-beanstalk-cicd"
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
  default     = "main"
}

