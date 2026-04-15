---
layout: default
title: 4.1 Criando Três Subnets
permalink: /fases/04-subnets-dinamicas/criando-tres-subnets/
prev_title: 4. Subnets Dinâmicas
prev_url: /fases/04-subnets-dinamicas/
next_title: 4.2 CIDR em Variáveis
next_url: /fases/04-subnets-dinamicas/cidr-em-variaveis/
---

# 4.1 Criando Três Subnets

Com a lista de zonas de disponibilidade já consultada na fase anterior, o próximo passo é criar três recursos de subnet.

<blockquote><strong>⚡ Visão rápida:</strong> aqui vamos distribuir a rede em três zonas, criando uma subnet por zona de disponibilidade.</blockquote>

A proposta é simples criar uma subnet em cada uma das 3 zonas de disponibilidade
Esse desenho é útil porque permite espalhar carga entre zonas diferentes.

Imagine, por exemplo, que queremos colocar uma cópia de um servidor em cada zona de disponibilidade.

Nesse cenário, cada servidor pode ser conectado a uma subnet diferente, e cada subnet fica associada a uma zona específica.

## 4.1.1 Criar o arquivo `subnet.tf`

Agora vamos usar o projeto atual para criar três subnets dentro da VPC que já existe.

Crie um arquivo chamado `subnet.tf`.

Nesse arquivo, adicione estes três recursos:

```hcl
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[2]}"
  }
}
```

Nesse exemplo:

- `vpc_id = aws_vpc.main.id` conecta cada subnet à VPC criada na fase anterior;
- cada `cidr_block` representa uma faixa diferente dentro da rede da VPC;
- `names[0]`, `names[1]` e `names[2]` pegam as três primeiras zonas disponíveis na região atual.
- a `tag Name` de cada subnet usa o prefixo da VPC e o nome da zona de disponibilidade.

Na prática, se a VPC estiver usando um nome como `andrew-42`, o resultado pode ficar algo como:

- `andrew-42-sa-east-1a`
- `andrew-42-sa-east-1b`
- `andrew-42-sa-east-1c`

## 4.1.2 Exibir os identificadores das subnets

Depois disso, ajuste o `output.tf` para exibir os identificadores criados:

```hcl
output "subnet_ids" {
  value = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
    aws_subnet.subnet_c.id
  ]
}
```

Isso ajuda a validar rapidamente que as três subnets foram criadas e também prepara o projeto para próximas etapas, onde esses IDs poderão ser reutilizados.

## 4.1.3 Aplicar

Agora execute:

```bash
tofu apply
```

Aqui a expectativa já é diferente da etapa anterior.

Desta vez, o plano mostrado pelo `apply` deve indicar criação de infraestrutura real, porque três novas subnets serão adicionadas à VPC.

Só confirme a execução se o plano mostrar exatamente esse tipo de mudança.

## 4.1.4 Resultado esperado

Ao final, o projeto deve continuar mostrando o `vpc_id`, a lista de zonas e também os IDs das três subnets.

Imagem de referência das subnets no painel da AWS:

![Subnets exibidas no painel da AWS]({{ '/fases/04-subnets-dinamicas/assets/4-1-subnets-painel-aws.png' | relative_url }})
