# Desafio 5 SantoDigital

Bem-vindo ao Desafio 5 SantoDigital! Este projeto foi criado para demonstrar a configuração de uma infraestrutura na nuvem utilizando o Terraform e o Google Cloud Platform (GCP).

## 📋 Documento Explicativo

### 1. Escolhas de Configuração

- **Rede VPC**: Criei uma rede VPC personalizada, sem sub-redes automáticas, para garantir controle total sobre a topologia da rede.

- **Sub-redes**: Duas sub-redes foram criadas em diferentes regiões para garantir alta disponibilidade e distribuição de carga:
  - `subnet1`: 192.168.1.0/24 (us-central1)
  - `subnet2`: 10.152.0.0/24 (us-east1)

- **Instâncias de VM**: Ultilizei instâncias do tipo `f1-micro` para minimizar custos, com sistema operacional Debian 11, onde o servidor Apache é instalado e configurado automaticamente via script de inicialização.

- **Firewall**: Regras de firewall foram configuradas para permitir tráfego HTTP (porta 80) para as VMs e o balanceador de carga.

- **Balanceador de Carga HTTP(S)**: Configurado para distribuir o tráfego entre as instâncias de VM em diferentes regiões, com verificação de integridade para garantir a disponibilidade.

### 2. Processo de Aplicação

Siga os passos abaixo para aplicar a configuração:

#### 2.1 Instalação do Terraform

Certifique-se de que o Terraform está instalado na sua máquina. Você pode baixar o Terraform [aqui](https://www.terraform.io/downloads.html).

#### 2.2 Autenticação no GCP

Configure o arquivo de credenciais `chave.json` no diretório do projeto:
```bash
export GOOGLE_APPLICATION_CREDENTIALS="caminho/para/sua/chave.json"
```
#### 2.3 Inicializar o Terraform

No diretório do projeto, execute o comando abaixo para baixar os plugins necessários:

```bash
terraform init
```
#### 2.4 Planejamento
Execute o comando abaixo para visualizar as mudanças que serão aplicadas. Este comando vai gerar um plano de execução mostrando os recursos que serão criados, modificados ou destruídos:

```bash
terraform plan
```
#### 2.5 Aplicação
Execute o comando abaixo para provisionar a infraestrutura. Quando solicitado, digite yes para confirmar a aplicação do plano:
```bash
terraform apply
```
#### 2.6 Verificação dos Recursos Criados
Após a aplicação, você pode verificar se os recursos foram criados corretamente de várias maneiras:

Visualização das Saídas no Terraform:
Execute o comando abaixo para visualizar as informações importantes, como endereços IP das instâncias e do balanceador de carga:

``` bash
terraform output
```
#### Verificação no Console do GCP:
- **Acesse o Google Cloud Console.**
- Navegue até **VPC Network** > **VPC networks** para verificar a rede **hackathon-vpc** e suas sub-redes.
- Em **Compute Engine** > **VM instances**, você deve ver as instâncias **vm-instance-01** e **vm-instance-02** criadas.
- Em **Network services** > **Load balancing**, verifique se o balanceador de carga **HTTP(S)** foi criado e está distribuindo o tráfego corretamente.
- Teste de Conectividade:
- Use o endereço **IP** externo do balanceador de carga (disponível no **output** do **Terraform** ou no Console do **GCP**) para testar a conectividade. Abra um navegador e digite o **P** na barra de endereços. Se o Apache foi  instalado corretamente, você deve ver a página padrão do Apache.

### 3. Limpeza de Recursos
Quando você terminar de usar a infraestrutura provisionada, é importante limpar os recursos para evitar cobranças desnecessárias. Para isso, execute o seguinte comando:

```bash
terraform destroy
```
Digite yes quando solicitado para confirmar a destruição de todos os recursos.
