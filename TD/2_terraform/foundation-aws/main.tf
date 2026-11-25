
# 1. Création du VPC AWS
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-terraform"
  }
}

# 2. Création du premier sous-réseau
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "subnet-terraform-a"
  }
}

# 3. Création du deuxième sous-réseau
resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name = "subnet-terraform-b"
  }
}

# 4. Groupe de sécurité des machines virtuelles
resource "aws_security_group" "vm_sg" {
  name   = "vm-terraform-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "vm-terraform-sg"
  }
}

# 5. Recherche d'une image Amazon Linux
data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 6. Création de deux machines virtuelles EC2
resource "aws_instance" "vm" {
  count         = 2
  ami           = data.aws_ami.linux.id
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

# 7. Groupe de sécurité de la base de données
resource "aws_security_group" "db_sg" {
  name   = "db-terraform-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "db-terraform-sg"
  }
}

# 8. Autoriser les VM à accéder à PostgreSQL
resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.vm_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

# 9. Configuration des sous-réseaux RDS
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

# 10. Création de la base de données PostgreSQL
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

# 11. Création de la zone DNS privée
resource "aws_route53_zone" "zone" {
  name = "meina.example.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Name = "zone-terraform"
  }
}

# 12. Création de l'enregistrement DNS des VM
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "www.meina.example.com"
  type    = "A"
  ttl     = 300

  records = aws_instance.vm[*].private_ip
}
