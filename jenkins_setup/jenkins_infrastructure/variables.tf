variable "region" {
  description = "AWS region (e.g., eu-west-3 for Paris)"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "bei_subnet_cidr" {
  description = "CIDR for the public subnet (must be within the VPC CIDR; use RFC1918 space)"
  type        = string
}

variable "bei_subnet_name" {
  description = "Name tag for the subnet"
  type        = string
}

variable "ami" {
  description = "AMI ID (Ubuntu)"
  type        = string
}

variable "instance_type" {
  description = "Instance type for controller and agents"
  type        = string
}

variable "sg_name" {
  description = "Security group name"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID attached to the VPC"
  type        = string
}

variable "rt_name" {
  description = "Route table name"
  type        = string
}

variable "key_name" {
  description = "AWS Key Pair name to create/use"
  type        = string
}

variable "key_path" {
  description = "Path to your public SSH key"
  type        = string
}

# Optional: keep this so your tfvars stays consistent even if unused
variable "igw_name" {
  description = "IGW name (not used; provided for compatibility with your tfvars)"
  type        = string
  default     = ""
}
