region          = "eu-west-3"

vpc_id          = "vpc-047d345071dd6261d"
bei_subnet_cidr = "50.20.1.0/28"     
bei_subnet_name = "bei_subnet"

ami             = "ami-01f23391a59163da9"
instance_type   = "t3.medium"

sg_name         = "sg_ansible"
igw_id          = "igw-0cab390f5f46c09ad"
igw_name        = "main-igw"         
rt_name         = "public-route-table"

key_name        = "bei2_pub_key"
key_path        = "C:/Users/Admin/.ssh/bei_key.pub"
