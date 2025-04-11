# Projeto Terraform - Grupo 6

Este projeto cria uma infraestrutura completa na AWS utilizando Terraform. Ele é composto por rede, duas instâncias EC2 (pública e privada), S3, NAT Gateway e muito mais.

---

## ✅ Recursos Criados

### 🌐 Rede (VPC e Subnets)
- `aws_vpc.g6_vpc` - VPC principal do projeto
- `aws_subnet.g6_subnet_publica` - Subnet pública
- `aws_subnet.g6_subnet_privada` - Subnet privada

### 📡 Internet e Roteamento
- `aws_internet_gateway.g6_igw` - Internet Gateway para a VPC
- `aws_nat_gateway.g6_nat` - NAT Gateway para dar acesso à subnet privada
- `aws_route_table.g6_route_table` - Tabela de rotas da subnet pública
- `aws_route_table.g6_private_rtb` - Tabela de rotas da subnet privada
- `aws_route_table_association.g6_assoc` - Associação da tabela pública
- `aws_route_table_association.g6_private_rtb_assoc` - Associação da tabela privada

### 🖥️ Instâncias EC2
- `aws_instance.g6_ec2` - EC2 pública com IP acessível
- `aws_instance.g6_ec2_privada` - EC2 privada (acessível apenas pela pública via SSH)

### 🔐 Segurança
- `aws_security_group.g6_sg_ec2` - Security Group com portas 22 (SSH) e 80 (HTTP)

### ☁️ Armazenamento
- `aws_s3_bucket.g6_bucket` - Bucket S3
- `random_id.g6_bucket_id` - ID aleatório para nomear o bucket

### 🌍 Rede Pública
- `aws_eip.g6_eip` - Elastic IP para o NAT Gateway

---

## 🚀 Como usar

### 1. Pré-requisitos
- Instalar Terraform: https://developer.hashicorp.com/terraform/downloads
- Ter uma conta AWS com acesso ao EC2, VPC, S3 e chaves SSH válidas
- Executar `aws configure` para autenticar

### 2. Baixar e extrair o projeto
```bash
unzip terraform_grupo6_cloudlab_ok.zip
cd terraform_grupo6
```

### 3. Inicializar e aplicar o Terraform
```bash
terraform init
terraform apply
```

Digite `yes` quando for solicitado.

### 4. Acessar a EC2 pública
```bash
ssh -i "key-publica-g6.pem" ubuntu@<IP_PUBLICO>
```

### 5. Acessar a EC2 privada via bastion
```bash
ssh -i "key-privada-g6.pem" ubuntu@<IP_PRIVADO>
```

### 6. Listar recursos criados
```bash
terraform state list
```

### 7. Destruir recursos (opcional)
```bash
terraform destroy
```

---

## 📌 Observações

- Este projeto foi desenvolvido em ambiente de laboratório (ex: AWS Educate, Cloud Lab).
- O bloco de Lambda foi removido por falta de permissão para criar roles IAM.