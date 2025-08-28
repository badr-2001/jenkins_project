variable "vpc_id" {
  type =string
}

variable "bei_subnet_cidr" {
  type = string
}

variable "bei_subnet_name" {
  type = string
}

variable "ami" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_name_1" {
  description = "Name for the first EC2 instance"
  type        = string
}

variable "ec2_name_2" {
  description = "Name for the second EC2 instance"
  type        = string
}

variable "sg_name" {
  type = string
}
variable "igw_id" {
  type = string
}
variable "igw_name" {
  type = string
}

variable "rt_name" {
  type = string
}
variable "key_path" {
  type = string
}