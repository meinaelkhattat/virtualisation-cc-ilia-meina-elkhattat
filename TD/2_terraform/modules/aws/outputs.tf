# 3. Identifiant du VPC AWS
output "vpc_id" {
  description = "Identifiant du VPC AWS créé"
  value       = aws_vpc.main.id
}