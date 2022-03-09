output "browser_connection_string" {
  description = "Website Connection"
  value       = "http://${module.ec2.public_ip}:8000"
}

output "ssh_connection_string" {
  description = "SSH Connection"
  value       = "ssh -i ${module.ssh-key.key_name}.pem ec2-user@${module.ec2.public_ip}"
}
