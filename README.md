# eadskill-repository

Este repositório contém o pipeline de CI/CD para a implantação de uma aplicação na AWS usando GitHub Actions, ECR, ECS/EKS e Terraform. Além disso, inclui um script de backup para o banco de dados PostgreSQL.

Estrutura do Projeto

terraform/ - Configuração da infraestrutura na AWS

.github/workflows/ci-cd.yml - Pipeline de CI/CD

.github/workflows/backup.yml - Pipeline de CI/CD

backup.go - Script de backup do banco de dados PostgreSQL

devops-store-application/backend/ - Código do backend da aplicação

devops-store-application/populate/ - Serviço de população de dados

# Execução do Pipeline de CI/CD
1) Crie um arquivo .secrets na raiz e adicione os seguintes segredos:

AWS_ACCESS_KEY_ID=Chave de acesso AWS
AWS_SECRET_ACCESS_KEY=Chave secreta da AWS

2) Rodando Localmente com ACT

brew install act  # Para macOS
Ou
sudo apt install act  # Para Linux

Rodar o pipeline simulando a branch main
ACT=true act --secret-file .secrets

# Script Backup do PostgreSQL

Edite o arquivo backup.go e configure as variáveis:
AWS_REGION="us-east-1"
S3_BUCKET="meu-bucket-backup"
DB_HOST="meu-rds-endpoint"
DB_NAME="meu-banco"
DB_USER="meu-usuario"
DB_PASSWORD="minha-senha"

Dê permissão de execução: chmod +x scripts/backup.sh

Rode manualmente: ./backup.go

Para rodar diariamente execute a pipeline backup.yml dentro de .github/workflows/
