# 2. Variables du VPC AWS
variable "vpc_name" {
  description = "Nom du VPC AWS"
  type        = string
  default     = "vpc-terraform"
}

variable "vpc_cidr" {
  description = "Plage d'adresses IP du VPC"
  type        = string
  default     = "10.0.0.0/16"
}