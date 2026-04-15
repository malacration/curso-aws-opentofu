---
layout: default
title: 4.2 CIDR em Variáveis
permalink: /fases/04-subnets-dinamicas/cidr-em-variaveis/
prev_title: 4.1 Criando Três Subnets
prev_url: /fases/04-subnets-dinamicas/criando-tres-subnets/
next_title: 4.3 Recursos Dinâmicos
next_url: /fases/04-subnets-dinamicas/recursos-dinamicos/
---

# 4.2 CIDR em Variáveis

Nesta etapa, vamos tirar os `cidr_block` do código fixo e colocar esses valores em variáveis do projeto.

<blockquote><strong>⚡ Visão rápida:</strong> a VPC e as subnets usam CIDRs diferentes, então vamos declarar variáveis distintas para cada uma delas. O CIDR da VPC será um valor simples, e os CIDRs das subnets serão uma lista.</blockquote>

## 4.2.1 Declarar as variáveis

No `variables.tf`, adicione estes blocos:

```hcl
variable "vpc_cidr_block" {
  type = string
}

variable "subnet_cidr_blocks" {
  type = list(string)
}
```

Aqui a separação é proposital:

- `vpc_cidr_block` representa a rede principal da VPC;
- `subnet_cidr_blocks` representa as três redes menores das subnets.

Ou seja: a VPC e as subnets não compartilham a mesma variável, porque exercem papéis diferentes no projeto.

## 4.2.2 Preencher os valores no `terraform.tfvars`

Agora ajuste o `terraform.tfvars`:

```hcl
vpc_cidr_block = "10.0.0.0/16"

subnet_cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]
```

Nesse desenho:

- o CIDR da VPC continua sendo um único valor;
- os CIDRs das subnets formam uma lista com três posições.

## 4.2.3 Ajustar a VPC e as subnets

Agora atualize os arquivos que usam esses valores.

No recurso da VPC em `main.tf`, substitua o valor fixo por:

```hcl
cidr_block = var.vpc_cidr_block
```

No `subnet.tf`, ajuste manualmente as três subnets para usar a lista:

```hcl
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[2]
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[2]}"
  }
}
```

Aqui a ideia é fazer a referência ao array de forma manual e explícita.

Ou seja:

- `subnet_a` usa a posição `[0]`;
- `subnet_b` usa a posição `[1]`;
- `subnet_c` usa a posição `[2]`.
- a `tag Name` continua sendo montada com o prefixo da VPC e o nome da AZ correspondente.

Trocas de `cidr_block` em cada subnet:

<blockquote style="border-left-color: #22c55e; background: rgba(34, 197, 94, 0.08);">
  <strong style="color: #22c55e;">subnet_a</strong><br>
  <code style="color: #22c55e;">cidr_block = var.subnet_cidr_blocks[0]</code>
</blockquote>

<blockquote style="border-left-color: #22c55e; background: rgba(34, 197, 94, 0.08);">
  <strong style="color: #22c55e;">subnet_b</strong><br>
  <code style="color: #22c55e;">cidr_block = var.subnet_cidr_blocks[1]</code>
</blockquote>

<blockquote style="border-left-color: #22c55e; background: rgba(34, 197, 94, 0.08);">
  <strong style="color: #22c55e;">subnet_c</strong><br>
  <code style="color: #22c55e;">cidr_block = var.subnet_cidr_blocks[2]</code>
</blockquote>

## 4.2.4 Aplicar

Agora execute:

```bash
tofu apply
```

Se você manteve exatamente os mesmos CIDRs que já estavam no projeto, a expectativa é não haver mudança real na infraestrutura.

Nesse caso, a vantagem obtida aqui é organização e parametrização.

## 4.2.5 Resultado esperado

Na prática, esta etapa reforça quatro ideias:

- 📦 valores importantes do projeto podem sair do código fixo e virar variáveis;
- 🌐 o CIDR da VPC é uma entrada diferente do CIDR das subnets;
- 📚 uma lista funciona bem quando várias subnets seguem a mesma lógica;
- 🧭 mesmo usando lista, ainda podemos ligar cada subnet manualmente a uma posição específica.
