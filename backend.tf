# backend.tf

terraform {
  backend "gcs" {
    bucket = "skytjenester-bucket"
    prefix = "skytjenester-bucket/default.tfstate"
  }
}
