# Infraestrutura como Código (IaC) - Banco de Dados (RDS)

Este diretório contém todo o código de Infraestrutura como Código (IaC) para provisionar o banco de dados PostgreSQL gerenciado (AWS RDS) para o projeto Garage Management System.

## 🏛️ Arquitetura e Dependências

A arquitetura deste repositório é baseada na leitura de um estado remoto (`terraform_remote_state`). Ele depende fundamentalmente dos recursos de rede (VPC, Subnets Privadas e Security Groups) criados pelo repositório `garage-management-infra` ([garage-management-infra](https://github.com/12SOAT-Workshop-FIAP/garage-management-infra)).

O `main.tf` deste projeto lê o arquivo de estado `garage-management-infra/terraform.tfstate` para obter os IDs da rede e, em seguida, provisiona a instância do RDS dentro dessa rede segura.

O provisionamento deve **obrigatoriamente** seguir esta ordem:

1.  Aplicar o repositório `garage-management-infra`.
2.  Aplicar este repositório (`garage-management-database`).

## ⚠️ Aviso Importante de Configuração

Para facilitar a execução de migrações iniciais, as seguintes configurações estão ativadas intencionalmente:

1.  `publicly_accessible = true`: O banco de dados será provisionado com um endereço IP público. Isso facilita o acesso direto de uma máquina de desenvolvimento para rodar `migrations` sem a necessidade de _bastion hosts_ ou VPNs.
2.  `skip_final_snapshot = true`: O Terraform não criará um snapshot final ao destruir a instância, tornando o processo de `terraform destroy` mais rápido.

**Em um ambiente de produção, ambas as configurações deveriam ser `false` para garantir a segurança e a recuperação de dados.**

## 🚀 Instruções para Provisionamento

### Pré-requisitos

1.  **Terraform CLI:** Instalado na sua máquina.
2.  **AWS CLI:** Instalado e configurado.
3.  **Backend Provisionado:** Os recursos do `backend` (Bucket S3 e tabela DynamoDB) devem existir.
4.  **Infra Base Aplicada:** O repositório `garage-management-infra` deve ter sido aplicado com sucesso, pois este repositório depende dos outputs dele.

### Passos para Execução

#### Deploy Automatizado (CI/CD via GitHub Actions)
Esta é a forma recomendada para a branch main.

1.  **Configure os Secrets no GitHub:**

    Vá em Settings > Secrets and variables > Actions e adicione:

    - AWS_ACCESS_KEY_ID: Sua Access Key.
    - AWS_SECRET_ACCESS_KEY: Sua Secret Key.
    - AWS_SESSION_TOKEN: Se usar credenciais temporárias.
    - DB_USERNAME: O usuário master do banco (ex: postgres).
    - DB_PASSWORD: A senha master do banco (use uma senha forte).

2.  **Disparar o Deploy:**

    - Faça um push na branch main contendo alterações na pasta garage-management-database.
    - O workflow iniciará automaticamente o terraform plan e, se bem-sucedido, o terraform apply.

#### Execução Manual (Desenvolvimento Local)
1.  **Crie o arquivo de variáveis:**
    Crie um arquivo chamado `terraform.tfvars` e adicione as credenciais do banco de dados.

    ```hcl
    # garage-management-database/terraform.tfvars

    db_username = "seu_usuario_aqui"
    db_password = "sua_senha_segura_aqui"
    ```

    _Este arquivo já está no `.gitignore`._

2.  **Inicialize o Terraform:**
    Este comando irá baixar os provedores e configurar o backend, lendo o estado do bucket S3.

    ```bash
    terraform init
    ```

3.  **Planeje e Aplique:**
    Revise os recursos a serem criados e confirme a aplicação.

    ```bash
    terraform plan
    terraform apply
    ```

## 📜 Outputs do Módulo

Após a aplicação, os seguintes outputs estarão disponíveis:

- `db_endpoint`: O hostname (endpoint) de conexão do banco de dados.
- `db_name`: O nome do banco de dados (`garagemanagement` por padrão).
