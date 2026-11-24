output "ansible_control_node_public_ip" {
  description = "Public IP of the Ansible Control Node (EC2 #1)"
  value       = "EC2 #1 (Ansible Control Node): ${aws_instance.ansible_control_node.public_ip}"
}

output "devsecops_target_node_public_ip" {
  description = "Public IP of the DevSecOps Target Node (EC2 #2)"
  value       = "EC2 #2 (DevSecOps Target Node): ${aws_instance.devsecops_target_node.public_ip}"
}

output "devsecops_target_node_private_ip" {
  description = "Private IP of the DevSecOps Target Node (for Ansible inventory)"
  value       = "EC2 #2 Private IP (use in Ansible inventory): ${aws_instance.devsecops_target_node.private_ip}"
}

output "service_urls" {
  description = "DevSecOps service URLs"
  value = {
    Jenkins    = "http://${aws_instance.devsecops_target_node.public_ip}:8080"
    SonarQube  = "http://${aws_instance.devsecops_target_node.public_ip}:9000"
    Grafana    = "http://${aws_instance.devsecops_target_node.public_ip}:3000"
    Prometheus = "http://${aws_instance.devsecops_target_node.public_ip}:9090"
  }
}
