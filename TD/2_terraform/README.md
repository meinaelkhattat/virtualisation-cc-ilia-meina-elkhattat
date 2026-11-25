# TP Terraform

## GCP

### Étape 1 : Création du VPC

Commande :
terraform plan

Résultat :
Plan: 1 to add, 0 to change, 0 to destroy.

### Création du sous-réseau et de la VM

Commande exécutée :
`terraform validate`

Résultat :
Success! The configuration is valid.

Commande exécutée :
`terraform plan`

Résultat :
Plan: 3 to add, 0 to change, 0 to destroy.

### Configuration de Cloud SQL et du réseau privé

Commande : `terraform validate`

Résultat : Success! The configuration is valid.

Commande : `terraform plan`

Résultat : Plan: 6 to add, 0 to change, 0 to destroy.

### Configuration DNS

Ressources ajoutées :
- Zone DNS : zone-terraform
- Enregistrement DNS : www.meina.example.com

Commande : `terraform validate`

Résultat : Success! The configuration is valid.

Commande : `terraform plan`

Résultat : Plan: 8 to add, 0 to change, 0 to destroy.

### Étape 9 — Création de plusieurs VM

Méta-argument utilisé : count = 2

Machines virtuelles prévues :
- vm-terraform-1
- vm-terraform-2

Commande : terraform validate
Résultat : Success! The configuration is valid.

Commande : terraform plan
Résultat : Plan: 9 to add, 0 to change, 0 to destroy.