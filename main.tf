# Varaible for GCP authentication
variable "AUTH" {
  type = string
}

# The public SSH key to assign to the VM
variable "SSH_PUB_KEY" {
  type = string
}


# Information related to the provider
provider "google" {
  credentials = var.AUTH
  project     = "skytjenester"
  region      = "europe-west1"
}

# The virual machine
# TODO public ssh key med github env
resource "google_compute_instance" "skytjenester_vm" {
  name         = "skytjenester-vm"
  machine_type = "f1-micro"
  zone         = "europe-west1-c"

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
    # subnetwork = google_compute_subnetwork.default.id

    # Left empty to signal GCP to assign an IP
    access_config {

    }

  }

  metadata = {
    ssh-keys = var.SSH_PUB_KEY
  }

  # Bruk env varaibler
  # metadata = {
  #   ssh-keys = "Pette:${file("~/.ssh/skytjenester.pub")}"
  # }

}

# # Database instance to be created 
# resource "google_sql_database_instance" "skytjenester_db" {
#   name             = "skytjenester-db"
#   region           = "europe-west1"
#   database_version = "POSTGRES_14"

#   settings {
#     tier = "db-f1-micro" # Free tier usage
#   }
#   # ip_configuration {
#   #   ipv4_enabled    = true
#   #   private_network = google_compute_network.my_network.self_link # Link to the VPC (network)
#   #   require_ssl     = true
#   # }

# }

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





