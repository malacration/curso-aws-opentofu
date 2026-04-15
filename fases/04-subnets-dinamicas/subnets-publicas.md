---
layout: default
title: 4.4 Subnets Públicas
permalink: /fases/04-subnets-dinamicas/subnets-publicas/
prev_title: 4.3 Recursos Dinâmicos
prev_url: /fases/04-subnets-dinamicas/recursos-dinamicos/
next_title: 5. EC2 com HTTP
next_url: /fases/05-ec2-http/
---

# 4.4 Subnets Públicas

Nesta etapa, vamos tornar as três subnets públicas.

<blockquote><strong>⚡ Visão rápida:</strong> uma subnet pública é aquela que possui rota para a internet. Para isso, precisamos de três recursos: um Internet Gateway, uma Route Table e as associações entre as subnets e essa Route Table.</blockquote>

## 4.4.1 O que torna uma subnet pública?

Uma subnet criada na AWS não tem acesso à internet por padrão.

Para torná-la pública, duas condições precisam ser satisfeitas:

- a VPC precisa ter um **Internet Gateway** anexado;
- a subnet precisa estar associada a uma **Route Table** com uma rota para esse Internet Gateway.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway">Abrir documentação do recurso <code>aws_internet_gateway</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table">Abrir documentação do recurso <code>aws_route_table</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association">Abrir documentação do recurso <code>aws_route_table_association</code></a>
</blockquote>

## 4.4.2 Criar o Internet Gateway

O Internet Gateway é o componente que conecta a VPC à internet.

Adicione ao `subnet.tf`:

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}
```

Um ponto importante: cada VPC pode ter apenas um Internet Gateway. O recurso é declarado uma única vez e fica disponível para todas as subnets que precisarem de acesso à internet.

## 4.4.3 Criar a Route Table pública

A Route Table define para onde o tráfego de uma subnet deve ser encaminhado.

A rota `0.0.0.0/0` significa "qualquer destino não reconhecido vai para o Internet Gateway":

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}
```

## 4.4.4 Associar as subnets à Route Table

Criar a Route Table não é suficiente. Cada subnet precisa ser associada explicitamente a ela.

Como temos três subnets, usamos `count` novamente:

```hcl
resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.public.id
}
```

Aqui:

- `count = 3` cria uma associação para cada subnet;
- `aws_subnet.subnets[count.index].id` pega o ID da subnet correspondente;
- `aws_route_table.public.id` aponta para a mesma Route Table em todas as associações.

## 4.4.5 Exibir o ID do Internet Gateway

Adicione ao `output.tf`:

```hcl
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
```

Isso confirma que o Internet Gateway foi criado e exibe o ID para referência.

## 4.4.6 Aplicar

Execute:

```bash
tofu apply
```

O plano deve mostrar a criação de:

- 1 Internet Gateway;
- 1 Route Table com uma rota para `0.0.0.0/0`;
- 3 Route Table Associations.

## 4.4.7 Resultado esperado

Imagem de referência da VPC com o Internet Gateway conectado no painel da AWS:

![VPC com Internet Gateway no painel da AWS]({{ '/fases/04-subnets-dinamicas/assets/4-4-vpc-internet-gateway.png' | relative_url }})

Na prática, esta etapa reforça três ideias:

- 🌐 uma subnet só é pública quando tem rota para um Internet Gateway;
- 🔗 a Route Table é o elo entre a subnet e o Internet Gateway;
- 📋 a associação precisa ser declarada explicitamente — criar a Route Table não é suficiente.
