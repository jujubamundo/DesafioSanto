# DesafioSanto

Bem-vindo ao DesafioSanto! Este projeto foi criado para demonstrar a configuração de uma infraestrutura na nuvem utilizando o Terraform e o Google Cloud Platform (GCP).

## 📋 Documento Explicativo

### 1. Escolhas de Configuração

- **Rede VPC**: Criei uma rede VPC personalizada, sem sub-redes automáticas, para garantir controle total sobre a topologia da rede.

- **Sub-redes**: Duas sub-redes foram criadas em diferentes regiões para garantir alta disponibilidade e distribuição de carga:
  - `subnet1`: 192.168.1.0/24 (us-central1)
  - `subnet2`: 10.152.0.0/24 (us-east1)

- **Instâncias de VM**: Ultilizei instâncias do tipo `f1-micro` para minimizar custos, com sistema operacional Debian 11, onde o servidor Apache é instalado e configurado automaticamente via script de inicialização.

- **Firewall**: Regras de firewall foram configuradas para permitir tráfego HTTP (porta 80) para as VMs e o balanceador de carga.

- **Balanceador de Carga HTTP(S)**: Configurado para distribuir o tráfego entre as instâncias de VM em diferentes regiões, com verificação de integridade para garantir a disponibilidade.
