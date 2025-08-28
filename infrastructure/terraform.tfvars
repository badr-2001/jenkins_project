vpc_id              = "vpc-047d345071dd6261d"
bei_subnet_cidr  = "50.20.6.0/28"
bei_subnet_name = "bei_subnet"

ami                 = "ami-01f23391a59163da9"
instance_type       = "t3.micro"
ec2_name_1 = "bei2_ec2_1"
ec2_name_2 = "bei2_ec2_2"

sg_name = "sg_ansible"
igw_id="igw-0cab390f5f46c09ad"
igw_name="main-igw"
rt_name="public-route-table"
key_path = "/home/badr/.ssh/bei_key.pub"