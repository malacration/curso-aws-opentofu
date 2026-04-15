---
layout: default
title: 3.4 Contando Zonas de Disponibilidade
permalink: /fases/03-nuvem-particular-vpc/contando-zonas-de-disponibilidade/
prev_title: 3.3 Sem ClickOps
prev_url: /fases/03-nuvem-particular-vpc/sem-clickops/
next_title: 4. Subnets Dinâmicas
next_url: /fases/04-subnets-dinamicas/
---

# 3.4 Contando Zonas de Disponibilidade

Nesta etapa, vamos consultar quantas zonas de disponibilidade existem na região onde a nossa VPC está sendo criada e exibir esse valor em um `output`.

<blockquote><strong>⚡ Visão rápida:</strong> a VPC vive dentro de uma região. Então, na prática, vamos consultar as zonas de disponibilidade da região atual e usar esse resultado no projeto.</blockquote>

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones">Abrir documentação do data source <code>aws_availability_zones</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/values/outputs">Abrir documentação do bloco <code>output</code></a>
</blockquote>
- função `length`: https://opentofu.org/docs/language/functions/length/

## 3.4.1 Consultar as zonas disponíveis

No `main.tf`, adicione um bloco `data` como este:

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

Nesse bloco:

- `aws_availability_zones`: é a consulta ao provider AWS;
- `available`: é o nome lógico dado a essa consulta;
- `state = "available"`: filtra apenas zonas que estão disponíveis para uso.

Aqui não estamos criando infraestrutura nova.

Estamos apenas perguntando para a AWS quais zonas de disponibilidade estão disponíveis na região configurada pelo projeto.

## 3.4.2 Exibir a quantidade e a lista no `output`

Depois disso, ajuste o `output.tf` para exibir tanto a quantidade quanto a lista de zonas encontradas.

Adicione blocos como estes:

```hcl
output "quantidade_zonas_disponibilidade" {
  value = length(data.aws_availability_zones.available.names)
}

output "zonas_disponibilidade" {
  value = data.aws_availability_zones.available.names
}
```

No valor `length(data.aws_availability_zones.available.names)`:

- `data`: indica que estamos lendo um bloco de consulta;
- `aws_availability_zones`: é o tipo da consulta;
- `available`: é o nome lógico dessa consulta;
- `names`: é a lista de nomes das zonas encontradas;
- `length(...)`: conta quantos itens existem nessa lista.

No valor `data.aws_availability_zones.available.names`:

- `data`: indica que estamos lendo um bloco de consulta;
- `aws_availability_zones`: é o tipo da consulta;
- `available`: é o nome lógico dessa consulta;
- `names`: é a lista com os nomes das zonas encontradas.

Ou seja:

- `quantidade_zonas_disponibilidade` mostra o total;
- `zonas_disponibilidade` mostra a lista.

## 3.4.3 Aplicar

Agora execute:

```bash
tofu apply
```

O `apply` vai mostrar o plano antes de pedir confirmação.

Aqui a regra é importante: só aceite continuar se o plano não mostrar mudança de infraestrutura real, e sim apenas mudança de `output`.

Ou seja, a expectativa é não criar, não alterar e não destruir recursos da AWS nesta etapa.

O que muda aqui é a informação exibida pelo projeto.

Ao final, o projeto deve continuar mostrando o `vpc_id`, a quantidade de zonas disponíveis e também a lista dessas zonas.

Imagem de referência da lista de zonas no terminal:

![Lista de zonas de disponibilidade exibida no output]({{ '/fases/03-nuvem-particular-vpc/assets/3-4-lista-az-output.png' | relative_url }})

## 3.4.4 Resultado esperado

Na prática, essa etapa mostra duas ideias importantes:

- 📍 a VPC está presa a uma região;
- 🌐 as zonas de disponibilidade são uma característica da região;
- 📤 o OpenTofu consegue consultar esses dados e expor tanto o total quanto a lista em `output`.
