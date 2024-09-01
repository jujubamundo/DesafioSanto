output "instance_01_ip" {
  description = "Endereço IP da instância vm-instance-01"
  value       = google_compute_instance.vm_instance_01.network_interface[0].access_config[0].nat_ip
}

output "instance_02_ip" {
  description = "Endereço IP da instância vm-instance-02"
  value       = google_compute_instance.vm_instance_02.network_interface[0].access_config[0].nat_ip
}

output "load_balancer_ip" {
  description = "Endereço IP do Load Balancer"
  value       = google_compute_global_forwarding_rule.default.ip_address
}