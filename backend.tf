# backend.tf

terraform {
  backend "gcs" {
    bucket = "skytjenester-bucket"
    prefix = "default.tfstate"
  }
}
