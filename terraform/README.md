# Infraestrutura AWS com Terraform

## Visão Geral

Este repositório contém a infraestrutura como código (IaC) para provisionamento de ambientes AWS utilizando Terraform.  
A arquitetura foi projetada com foco em modularidade, reutilização, segurança e separação entre ambientes.

Os ambientes suportados são:

- dev
- staging
- prod

## Arquitetura

A infraestrutura básica inclui:

- VPC
- Subnets públicas e privadas
- Internet Gateway
- Security Groups
- EC2
- Application Load Balancer (ALB)
- IAM Role / Instance Profile
- AWS Secrets Manager

### Fluxo de tráfego

Internet -> ALB -> EC2

### Objetivo de cada recurso

#### VPC
Responsável pelo isolamento de rede da aplicação.

#### Subnets públicas
Hospedam recursos expostos publicamente, como o ALB.

#### Subnets privadas
Hospedam instâncias EC2 da aplicação, reduzindo exposição direta à internet.

#### Security Groups
Controlam o tráfego de entrada e saída entre ALB, EC2 e internet.

#### EC2
Executa a aplicação.

#### ALB
Distribui o tráfego entre instâncias e fornece ponto único de entrada.

#### IAM Role / Instance Profile
Concede permissões controladas para a EC2 acessar serviços AWS, como SSM e Secrets Manager.

#### AWS Secrets Manager
Armazena segredos e credenciais sensíveis fora do código-fonte.

## Estrutura do projeto

```text
terraform/
├── modules/
│   ├── vpc/
│   ├── security/
│   ├── iam/
│   ├── ec2/
│   ├── alb/
│   └── secrets/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── versions.tf
├── providers.tf
├── backend.tf
└── README.md