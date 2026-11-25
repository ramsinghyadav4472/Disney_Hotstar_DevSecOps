variable "region" {
  default     = "ap-south-1"
  description = "AWS region to launch instances in (Mumbai)"
}

variable "ami_id" {
  default     = "ami-00bb6a80f01f03502"
  description = "Ubuntu 22.04 LTS AMI ID for ap-south-1 (Mumbai)"
}

variable "key_name" {
  default     = "hotstar"
  description = "Name of your existing AWS Key Pair (must already exist in your AWS account)"
}
