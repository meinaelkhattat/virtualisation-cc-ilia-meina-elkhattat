
# 1. Utilisation du module VPC AWS
module "vpc" {
  source   = "../modules/aws"
  vpc_name = "vpc-terraform"
  vpc_cidr = "10.0.0.0/16"
}

# 2. Création du premier sous-réseau
resource "aws_subnet" "subnet_a" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "subnet-terraform-a"
  }
}

# 3. Création du deuxième sous-réseau
resource "aws_subnet" "subnet_b" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "subnet-terraform-b"
  }
}

# 4. Groupe de sécurité des VM
resource "aws_security_group" "vm_sg" {
  name   = "vm-terraform-sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "vm-terraform-sg"
  }
}

# 5. Création de deux machines virtuelles EC2
resource "aws_instance" "vm" {
  count = 2

  # AMI fictive utilisée uniquement pour tester Terraform
  ami           = "ami-0123456789abcdef0"
  instance_type = "t3.micro"

  subnet_id = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ][count.index]

  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  tags = {
    Name = "vm-terraform-${count.index + 1}"
  }
}

# 6. Groupe de sécurité PostgreSQL
resource "aws_security_group" "db_sg" {
  name   = "db-terraform-sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "db-terraform-sg"
  }
}

# 7. Autoriser les VM à accéder à PostgreSQL
resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.vm_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

# 8. Groupe de sous-réseaux pour RDS
resource "aws_db_subnet_group" "db_subnets" {
  name = "db-terraform-subnets"

  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  tags = {
    Name = "db-terraform-subnets"
  }
}

# 9. Création de la base de données PostgreSQL
resource "aws_db_instance" "db" {
  identifier                  = "db-terraform"
  allocated_storage           = 20
  engine                      = "postgres"
  instance_class              = "db.t3.micro"
  username                    = "dbadmin"
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  publicly_accessible = false
  skip_final_snapshot = true
}

# 10. Création de la zone DNS privée
resource "aws_route53_zone" "zone" {
  name = "meina.example.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name = "zone-terraform"
  }
}

# 11. Création de l'enregistrement DNS
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "www.meina.example.com"
  type    = "A"
  ttl     = 300

  records = aws_instance.vm[*].private_ip
}
