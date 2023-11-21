# The Provider block for credentials, permissions and specifying the project 
# to work with and the region to create resources in.
provider "google" {
  credentials = file("~/.config/gcloud/skytjenester_key.json")
  project     = "skytjenester"
  region      = "europe-west1"
}

# Kubernetes cluster for managing the containers 
# "google_container_cluster" == Kuberentes cluster
resource "google_container_cluster" "skytjenester_cluster" {
  name               = "skytjenester-cluster"
  location           = "europe-west1-b"
  initial_node_count = 1
}

# Database instance to be created 
# resource "google_sql_database_instance" "skytjenesterdb" {
#   name             = "skytjenesterdb"
#   region           = "europe-west1"
#   database_version = "POSTGRES_14"

#   settings {
#     tier = "db-f1-micro" # Free tier usage
#   }

# }







