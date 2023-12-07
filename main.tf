# Backend configuration used for resource state
terraform {
  backend "gcs" {
    bucket = "skytjenester-bucket"
  }
}

# Information related to the provider
provider "google" {
  project = "skytjenester"
  region  = "europe-west1"
}

# The public SSH key to assign to the VM
variable "SSH_PUB_KEY" {
  type = string
}

# The zone which the resources should be created in
variable "ZONE" {
  type = string
}
# The virual machine
resource "google_compute_instance" "skytjenester_vm" {
  name         = "skytjenester-vm"
  machine_type = "f1-micro"
  zone         = var.ZONE

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  # Install Flask
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"

  # Applied firewall rules
  tags = ["flask", "ssh"]

  # Links the instace to the subnet for IP adresses
  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    # Left empty to signal GCP to assign an IP
    access_config {

    }

  }
  metadata = {
    ssh-keys = var.SSH_PUB_KEY
  }
}

# Network 
resource "google_compute_network" "vpc_network" {
  auto_create_subnetworks = false
  name                    = "skytjenester-net"
}

# Subnet for the instances
resource "google_compute_subnetwork" "default" {
  name          = "skytjenester-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.id
}

# Firewall configuration to allow ssh 
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# Firewall config to allow tcp 
resource "google_compute_firewall" "flask" {
  name    = "flask-app-firewall"
  network = google_compute_network.vpc_network.id

  # Firewall rule name
  target_tags = ["flask"]
  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
  source_ranges = ["0.0.0.0/0"]
}





