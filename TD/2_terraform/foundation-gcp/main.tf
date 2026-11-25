
# 1. Utilisation du module VPC GCP
module "vpc" {
  source   = "../modules/gcp"
  vpc_name = "vpc-terraform"
}

# 2. Création du sous-réseau
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-terraform"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = module.vpc.vpc_id
}

# 3. Création de plusieurs machines virtuelles
resource "google_compute_instance" "vm" {
  count        = 2
  name         = "vm-terraform-${count.index + 1}"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
  }
}

# 4. Création de la base de données PostgreSQL
resource "google_sql_database_instance" "db" {
  depends_on = [google_service_networking_connection.private_connection]

  name             = "db-terraform"
  database_version = "POSTGRES_15"
  region           = "europe-west1"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = module.vpc.vpc_id
    }
  }

  deletion_protection = false
}

# 5. Réservation d'une plage d'adresses IP privées
resource "google_compute_global_address" "private_ip" {
  name          = "private-ip-terraform"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.vpc_id
}

# 6. Création de la connexion réseau privée
resource "google_service_networking_connection" "private_connection" {
  network                 = module.vpc.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]
}

# 7. Création de la zone DNS
resource "google_dns_managed_zone" "zone" {
  name     = "zone-terraform"
  dns_name = "meina.example.com."
}

# 8. Création de l'enregistrement DNS
resource "google_dns_record_set" "www" {
  name         = "www.${google_dns_managed_zone.zone.dns_name}"
  managed_zone = google_dns_managed_zone.zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_instance.vm[0].network_interface[0].network_ip]
}
