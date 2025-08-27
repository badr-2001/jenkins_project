# Existing infra
data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_internet_gateway" "igw" {
  internet_gateway_id = var.igw_id
}

# Public subnet (instances will get public IPs)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.existing.id
  cidr_block              = var.bei_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.bei_subnet_name
  }
}

# Public route table -> IGW
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.existing.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group (open for demo; tighten later!)
module "jenkins_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = var.sg_name
  description = "Allow SSH, HTTP, Jenkins UI (8080) and JNLP agent (50000); all egress"
  vpc_id      = data.aws_vpc.existing.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      # Jenkins inbound agent (JNLP). Remove if you only use SSH agents.
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]
}

# SSH key
resource "aws_key_pair" "bei_key" {
  key_name   = var.key_name
  public_key = file(var.key_path)
}

# ----------------------
# EC2 Instances (4 total)
# ----------------------

module "jenkins_master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins_master"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bei_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins_master"
    Role = "jenkins_controller"
  }
}

module "jenkins_slave1" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins_slave1"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bei_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins_slave1"
    Role = "jenkins_agent"
  }
}

module "jenkins_slave2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins_slave2"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bei_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins_slave2"
    Role = "jenkins_agent"
  }
}

module "jenkins_slave3" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins_slave3"
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.bei_key.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins_slave3"
    Role = "jenkins_agent"
  }
}

# ----------------------
# Outputs (IPs)
# ----------------------
output "jenkins_master_public_ip" {
  description = "Public IP of Jenkins controller"
  value       = module.jenkins_master.public_ip
}

output "jenkins_master_private_ip" {
  description = "Private IP of Jenkins controller"
  value       = module.jenkins_master.private_ip
}

output "jenkins_agents_public_ips" {
  description = "Public IPs of Jenkins agents"
  value = {
    slave1 = module.jenkins_slave1.public_ip
    slave2 = module.jenkins_slave2.public_ip
    slave3 = module.jenkins_slave3.public_ip
  }
}

output "jenkins_agents_private_ips" {
  description = "Private IPs of Jenkins agents"
  value = {
    slave1 = module.jenkins_slave1.private_ip
    slave2 = module.jenkins_slave2.private_ip
    slave3 = module.jenkins_slave3.private_ip
  }
}