# TP Terraform

## 1. Infrastructure GCP (Google Cloud Platform)

### Étape 1 — Création du VPC

Création d'un réseau VPC nommé `vpc-terraform`.

**Commande exécutée :**
```bash
terraform plan
```

**Résultat :**
```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

### Étape 2 — Création du sous-réseau et de la VM

Création d'un sous-réseau `subnet-terraform` et d'une machine virtuelle Debian.

**Commandes exécutées :**
```bash
terraform validate
terraform plan
```

**Résultats :**
```text
Success! The configuration is valid.
Plan: 3 to add, 0 to change, 0 to destroy.
```

### Étape 3 — Configuration de Cloud SQL et du réseau privé

Ajout d'une base PostgreSQL et configuration de la connexion privée avec le VPC.

Ressources utilisées :
- `google_sql_database_instance`
- `google_compute_global_address`
- `google_service_networking_connection`

**Commandes exécutées :**
```bash
terraform validate
terraform plan
```

**Résultats :**
```text
Success! The configuration is valid.
Plan: 6 to add, 0 to change, 0 to destroy.
```

### Étape 4 — Configuration DNS

Création d'une zone DNS et d'un enregistrement DNS.

Ressources :
- Zone DNS : `zone-terraform`
- Enregistrement DNS : `www.meina.example.com`

**Commandes exécutées :**
```bash
terraform validate
terraform plan
```

**Résultats :**
```text
Success! The configuration is valid.
Plan: 8 to add, 0 to change, 0 to destroy.
```

### Étape 5 — Création de plusieurs machines virtuelles

Utilisation du méta-argument Terraform `count = 2`.

Machines virtuelles prévues :
- `vm-terraform-1`
- `vm-terraform-2`

**Commandes exécutées :**
```bash
terraform validate
terraform plan
```

**Résultats :**
```text
Success! The configuration is valid.
Plan: 9 to add, 0 to change, 0 to destroy.
```

## 2. Infrastructure AWS (Amazon Web Services)

Création d'une infrastructure AWS dans la région `eu-west-3` (Paris).

Ressources configurées :
- VPC et deux sous-réseaux
- Deux machines virtuelles EC2
- Groupes de sécurité
- Base de données PostgreSQL avec Amazon RDS
- Zone DNS privée et enregistrement Route 53

### Vérification AWS sans compte

Le provider AWS a été configuré pour désactiver certaines vérifications d'authentification.

Une AMI fictive a été utilisée pour tester la configuration sans disposer d'un compte AWS.

**Commandes exécutées :**
```bash
terraform init
terraform validate
```

**Résultat :**
```text
Success! The configuration is valid.
```

**Commande de simulation :**
```bash
AWS_ACCESS_KEY_ID=fake \
AWS_SECRET_ACCESS_KEY=fake \
AWS_EC2_METADATA_DISABLED=true \
terraform plan -refresh=false
```

**Résultat :**
```text
Plan: 12 to add, 0 to change, 0 to destroy.
```

Le plan Terraform AWS a été généré avec succès sans identifiants réels.

Cette vérification ne garantit pas que toutes les ressources pourraient être déployées avec les paramètres actuels.

## 3. Modules Terraform

### Module GCP

Création d'un module VPC réutilisable dans `modules/gcp`.

Fichiers :
- `main.tf` : création du VPC
- `variables.tf` : définition des variables
- `outputs.tf` : récupération de l'identifiant du VPC

**Résultats :**
```text
terraform validate : Success
terraform plan : 9 to add, 0 to change, 0 to destroy.
```

### Module AWS

Création d'un module VPC réutilisable dans `modules/aws`.

Fichiers :
- `main.tf` : création du VPC
- `variables.tf` : définition des variables
- `outputs.tf` : récupération de l'identifiant du VPC

**Résultats :**
```text
terraform validate : Success
terraform plan : 12 to add, 0 to change, 0 to destroy.
```

## 4. Déploiement et sécurité

Aucune commande `terraform apply` n'a été exécutée.

Les infrastructures GCP et AWS ont été définies et vérifiées avec `terraform validate` et `terraform plan`.

Pour GCP, un jeton fictif a été utilisé pour effectuer le plan sans authentification réelle.

Pour AWS, des identifiants et une AMI fictifs ont permis de générer un plan sans compte AWS.

Les fichiers temporaires Terraform et les fichiers d'état sont exclus du dépôt Git grâce au `.gitignore`.

Le code et les modules Terraform sont conservés dans le même dépôt GitHub que les autres travaux pratiques.