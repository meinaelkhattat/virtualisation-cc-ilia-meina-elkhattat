terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "polytech-dijon"
  region  = "europe-west1"
  access_token = "patate"
}