#!/bin/bash

echo "🧹 Limpando arquivos locais do Terraform..."

# Remove os arquivos e diretórios que o Terraform gera
rm -rf .terraform
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -f crash.log
rm -f .terraform.lock.hcl

echo "✅ Limpeza concluída!"
