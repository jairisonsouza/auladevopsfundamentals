# Terraform DevOps EC2 Setup com Projeto Adianti Framework

Este projeto utiliza Terraform para provisionar uma instância EC2 na AWS com Ubuntu Server, instalar ferramentas DevOps básicas e fazer o deploy automático de um projeto PHP baseado no Adianti Framework.

## Recursos Criados

- Instância EC2 (Ubuntu 22.04)
- Security Group com acesso SSH (porta 22), HTTP (80) e HTTPS (443)
- Instalação automatizada:
  - Git
  - Docker e Docker Compose
  - kubectl
  - Projeto Adianti Framework via GitHub

## Pré-requisitos

- Conta na AWS
- [Terraform](https://www.terraform.io/downloads)
- Par de chaves SSH criado (`~/.ssh/id_rsa` e `~/.ssh/id_rsa.pub`)
- Permissões suficientes na AWS para criar EC2, VPC e Security Groups

## Uso

### 1. Clone este repositório

```bash
git clone https://github.com/seuusuario/seurepo.git
cd seurepo
```

### 2. Inicialize o Terraform

```bash
terraform init
```

### 3. Aplique o plano

```bash
terraform apply
```

Ao final, será exibido o IP público da instância criada.

### 4. Acesse a aplicação

Abra seu navegador e acesse:

```
http://<IP_PÚBLICO>
```

### 5. Destruir os recursos

```bash
terraform destroy -auto-approve
```

## Sobre o Projeto Adianti

O projeto é clonado diretamente do repositório:

[https://github.com/jairisonsouza/adiantiframework](https://github.com/jairisonsouza/adiantiframework)

Ao final da criação da instância, o `docker-compose up -d` será executado automaticamente.

## Segurança

Este projeto abre portas públicas (22, 80, 443) para o mundo inteiro. Para ambientes de produção, recomenda-se restringir os IPs permitidos no Security Group.
