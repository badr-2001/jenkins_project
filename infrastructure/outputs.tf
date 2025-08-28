output "ec2_instance_1_public_ip" {
  description = "Public IP of EC2 instance 1"
  value       = module.ec2_instance_1.public_ip
}

output "ec2_instance_2_public_ip" {
  description = "Public IP of EC2 instance 2"
  value       = module.ec2_instance_2.public_ip
}