
# 3. Identifiant du VPC
output "vpc_id" {
  description = "Identifiant du VPC créé"
  value       = google_compute_network.vpc.id
}
