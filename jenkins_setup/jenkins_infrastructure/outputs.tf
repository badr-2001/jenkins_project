# ----------------------
# Outputs (IPs)
# ----------------------
output "jenkins_master_public_ip" {
  description = "Public IP of Jenkins controller"
  value       = module.jenkins_master.public_ip
}

output "jenkins_agents_public_ips" {
  description = "Public IPs of Jenkins agents"
  value = {
    slave1 = module.jenkins_slave1.public_ip
    slave2 = module.jenkins_slave2.public_ip
    slave3 = module.jenkins_slave3.public_ip
  }
}
