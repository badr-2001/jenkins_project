data "aws_vpc" "existing" {
  id = var.vpc_id
}

resource "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.existing.id
  cidr_block        = var.bei_subnet_cidr
  tags = {
    Name = var.bei_subnet_name
  }
}

module "ec2_instance_1" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name           = var.ec2_name_1
  ami            = var.ami
  instance_type  = var.instance_type
  key_name = data.aws_key_pair.bei2_pub_key.key_name

  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
    associate_public_ip_address = true
  tags = {
    Name = var.ec2_name_1
    Role = "bei_front"
  }

}



module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name           = var.ec2_name_2
  ami            = var.ami
  instance_type  = var.instance_type
  key_name = data.aws_key_pair.bei2_pub_key.key_name
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [module.ec2_sg.security_group_id] 
  associate_public_ip_address = true

  tags = {
    Name = var.ec2_name_2
    Role = "bei_front"
  }

}

module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = var.sg_name
  description = "Allow only SSH inbound , 8080 jenkins and 80 for apache2, all outbound"
  vpc_id      = data.aws_vpc.existing.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0" //not a real world case
    },
    {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0" //not a real world case
  },
  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0" 
  }
  ]

  egress_rules = ["all-all"]
}

data "aws_key_pair" "bei2_pub_key" {
  key_name = "bei2_pub_key"
}


data "aws_internet_gateway" "igw" {
  internet_gateway_id = var.igw_id
}

## Route Tables -----------------------------
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
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "local_file" "instance_ip_1" {
  content         = "ansible_host: ${module.ec2_instance_1.public_ip}"
  filename        = "${path.module}/../host_vars/front1.yml"
  file_permission = "0600"
}

resource "local_file" "instance_ip_2" {
  content         = "ansible_host: ${module.ec2_instance_2.public_ip}"
  filename        = "${path.module}/../host_vars/front2.yml"
  file_permission = "0600"
}