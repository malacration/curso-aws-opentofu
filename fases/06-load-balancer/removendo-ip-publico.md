---
layout: default
title: 6.2 Removendo o IP Público da EC2
permalink: /fases/06-load-balancer/removendo-ip-publico/
prev_title: 6.1 Criando o Load Balancer
prev_url: /fases/06-load-balancer/criando-o-load-balancer/
next_title: 6.3 Escalando as Instâncias
next_url: /fases/06-load-balancer/escalando-instancias/
---

# 6.2 Removendo o IP Público da EC2

Nesta etapa, vamos deixar a EC2 privada sem quebrar o servidor HTTP.

<blockquote><strong>⚡ Visão rápida:</strong> remover o IP público da instância sem mudar a rede faz o <code>user_data</code> falhar, porque a máquina perde a saída para a internet. A correção é separar a arquitetura: o ALB continua nas subnets públicas, a EC2 vai para uma subnet privada, e a saída para internet passa por um <code>NAT Gateway</code>. Para acesso administrativo pela interface da AWS, vamos usar <code>Session Manager</code>.</blockquote>

## 6.2.1 O problema de simplesmente remover o IP público

No item anterior, a EC2 ainda conseguia instalar o Apache no boot porque tinha acesso direto à internet.

Se você apenas trocar:

```hcl
associate_public_ip_address = false
```

sem ajustar a rede, a instância perde o caminho de saída. Isso afeta diretamente comandos como:

```bash
apt-get update -y
apt-get install -y apache2
```

Ou seja: o Load Balancer continua existindo, mas o backend deixa de responder corretamente.

## 6.2.2 Separar subnets públicas e privadas

Até aqui, o projeto vinha usando as mesmas subnets para tudo. Para uma arquitetura mais correta, vamos separar as responsabilidades:

- subnets públicas: ficam com o ALB e com o NAT Gateway;
- subnets privadas: ficam com as instâncias EC2;
- o tráfego de entrada passa pelo ALB;
- o tráfego de saída das EC2 privadas passa pelo NAT Gateway.

Crie um arquivo `private-subnet.tf`.

Nele, crie três subnets privadas, uma por zona de disponibilidade:

```hcl
resource "aws_subnet" "private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}
```

Agora declare a nova variável no `variables.tf`:

```hcl
variable "private_subnet_cidr_blocks" {
  type = list(string)
}
```

E preencha no `terraform.tfvars`:

```hcl
private_subnet_cidr_blocks = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24",
]
```

## 6.2.3 Criar o NAT Gateway

Crie um arquivo `nat.tf`.

O NAT Gateway precisa ficar em uma subnet pública e precisa de um Elastic IP:

```hcl
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets[0].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}
```

Esse NAT fica em uma subnet pública já existente. Ele será a saída compartilhada das instâncias privadas.

## 6.2.4 Criar a tabela de rotas privada

Ainda no arquivo `nat.tf`, crie a route table privada:

```hcl
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}
```

Agora a diferença de comportamento fica clara:

- as subnets públicas continuam apontando para o Internet Gateway;
- as subnets privadas apontam para o NAT Gateway;
- a EC2 privada sai para a internet, mas não recebe tráfego direto dela.

## 6.2.5 Mover a EC2 para a subnet privada

No `ec2.tf`, altere a subnet usada pela instância e remova o IP público:

```hcl
subnet_id                   = aws_subnet.private_subnets[0].id
associate_public_ip_address = false
```

Como a instância vai mudar de subnet e perder o IP público, o OpenTofu vai recriá-la.

## 6.2.6 Restringir o security group da EC2

No `ec2.tf`, mantenha o security group da aplicação aceitando tráfego HTTP somente do ALB:

```hcl
resource "aws_security_group" "http_server" {
  name        = "${var.vpc_name}-http-server"
  description = "Acesso HTTP restrito ao Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

Não abra a porta `80` para `0.0.0.0/0`, porque o objetivo aqui é que a aplicação só seja alcançada pelo Load Balancer.

## 6.2.7 Acesso administrativo pela UI da AWS

Como a instância não terá mais IP público, não faz sentido depender de SSH direto pela internet.

Para efeitos práticos deste curso, a melhor escolha é usar o **AWS Systems Manager Session Manager**, que abre um shell pela própria interface da AWS.

Existem outras formas de acesso administrativo:

- bastion host;
- EC2 Instance Connect Endpoint;
- VPN corporativa;
- acesso híbrido por Direct Connect.

Mas, para este projeto, `Session Manager` é a opção mais simples.

Crie um arquivo `ssm.tf`.

Primeiro, crie a role e o instance profile:

```hcl
resource "aws_iam_role" "ec2_ssm" {
  name = "${var.vpc_name}-ec2-ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.vpc_name}-ec2-ssm"
  role = aws_iam_role.ec2_ssm.name
}
```

Depois, volte ao arquivo `ec2.tf`, associe o profile à instância:

```hcl
iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name
```

Depois do `apply`, o acesso fica assim:

1. Abra o console da AWS.
2. Vá em `EC2`.
3. Abra a instância.
4. Clique em `Connect`.
5. Escolha `Session Manager`.
6. Abra a sessão no navegador.

Isso não é SSH tradicional pela internet. É uma sessão de shell pela infraestrutura gerenciada da própria AWS, o que combina melhor com uma instância privada.

## 6.2.8 Aplicar

Execute:

```bash
tofu apply
```

O plano deve mostrar:

- criação das subnets privadas;
- criação do Elastic IP do NAT;
- criação do NAT Gateway;
- criação da route table privada;
- associação das subnets privadas;
- criação da role/profile do SSM;
- recriação da EC2 por mudança de subnet e remoção do IP público.

Depois da aplicação, o painel da VPC deve mostrar a separação entre subnets públicas e privadas, com a nova estrutura já refletida no console:

![Subnets da VPC após as mudanças]({{ '/fases/06-load-balancer/assets/6-2-subnets-apos-mudancas.png' | relative_url }})

## 6.2.9 Testar

### Pela aplicação

O acesso pelo Load Balancer deve continuar funcionando:

```bash
curl http://$(tofu output -raw alb_dns)
```

### Pela instância

O output `ec2_public_ip` deve ficar vazio, porque a instância agora é privada.

### Pela UI da AWS

Abra a instância no console e valide que:

- ela está sem IP público;
- o ALB continua entregando a página;
- o acesso administrativo está disponível por `Session Manager`.
