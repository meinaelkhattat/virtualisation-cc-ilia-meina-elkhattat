resource "google_compute_network" "vpc" {
  name                    = "vpc-terraform"
  auto_create_subnetworks = false
}