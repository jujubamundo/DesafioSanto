terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("chave.json")
  project     = "desafiosanto"
  region      = "us-central1"
  zone        = "us-central1-c"
}

# Criação da VPC
resource "google_compute_network" "vpc_network" {
  name                    = "hackathon-vpc"
  auto_create_subnetworks = false
}

# Criação das Sub-redes
resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "192.168.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.152.0.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.name
}

# Criação das Instâncias de VM
resource "google_compute_instance" "vm_instance_01" {
  name         = "vm-instance-01"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet1.name

    access_config {
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
}

resource "google_compute_instance" "vm_instance_02" {
  name         = "vm-instance-02"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet2.name

    access_config {

    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
}

# Regras de Firewall para permitir o tráfego HTTP
resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Health Check
resource "google_compute_http_health_check" "default" {
  name               = "http-basic-check"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2
}

# Criação do Backend Service
resource "google_compute_backend_service" "default" {
  name          = "web-backend-service"
  health_checks = [google_compute_http_health_check.default.self_link]

  backend {
    group = google_compute_instance_group.instance_group_01.self_link
  }

  backend {
    group = google_compute_instance_group.instance_group_02.self_link
  }
}

# Configuração do URL Map
resource "google_compute_url_map" "default" {
  name            = "web-map"
  default_service = google_compute_backend_service.default.self_link
}

# Criação do HTTP(S) Load Balancer
resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "http-content-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}

# Criação dos Grupos de Instância para o Backend
resource "google_compute_instance_group" "instance_group_01" {
  name = "instance-group-01"
  zone = "us-central1-a"
  instances = [
    google_compute_instance.vm_instance_01.id
  ]
}

resource "google_compute_instance_group" "instance_group_02" {
  name = "instance-group-02"
  zone = "us-east1-b"
  instances = [
    google_compute_instance.vm_instance_02.id
  ]
}