---
layout: default
title: 2.4 Usando Variáveis para a Região
permalink: /fases/02-login-na-aws/usando-variaveis-para-a-regiao/
prev_title: 2.3 Organizando o Projeto
prev_url: /fases/02-login-na-aws/separando-o-projeto-em-varios-arquivos/
next_title: 2.5 Por Que Usar tfvars e Variáveis
next_url: /fases/02-login-na-aws/por-que-usar-tfvars-e-variaveis/
---

# 2.4 Usando Variáveis para a Região

Nesta etapa, vamos deixar a região do projeto parametrizada.

<blockquote><strong>⚡ Visão rápida:</strong> esta etapa substitui um valor fixo por uma entrada configurável, preparando o projeto para ambientes diferentes.</blockquote>

Em vez de escrever a região diretamente dentro do bloco do provider, vamos criar uma variável, preencher essa variável por um arquivo `.tfvars` e usar esse valor na configuração da AWS.

## 2.4.1 Criar o arquivo `variables.tf`

Crie um arquivo chamado `variables.tf`.

Nesse arquivo, declare uma variável para a região do projeto.

A ideia é simples: o `variables.tf` deve concentrar as entradas configuráveis do projeto.

Para este caso, a variável deve representar a região da AWS usada pelo provider.

O bloco pode ficar assim:

```hcl
variable "aws_region" {
  type = string
}
```

## 2.4.2 Criar o arquivo `terraform.tfvars`

Agora crie um arquivo chamado `terraform.tfvars`.

Esse arquivo será usado para preencher a variável declarada no passo anterior.

Aqui você deve informar o valor da região que o projeto vai usar, por exemplo `sa-east-1`.

O conteúdo pode ficar assim:

```hcl
aws_region = "sa-east-1"
```

Em outras palavras:

- `variables.tf` declara a variável;
- `terraform.tfvars` atribui um valor para ela.

## 2.4.3 Ajustar o `provider.tf`

Depois disso, atualize o `provider.tf`.

O valor da região não deve mais estar fixo no bloco do provider.

Em vez disso, o provider deve passar a usar a variável criada no projeto.

Assim, o provider deixa de depender de um valor hardcoded e passa a depender de uma entrada configurável.

O bloco deve ficar assim:

```hcl
provider "aws" {
  region = var.aws_region
}
```

## 2.4.4 Organização esperada

Ao final desta etapa, a organização fica assim:

- `variables.tf`: declara a variável da região
- `terraform.tfvars`: preenche a variável com o valor desejado
- `provider.tf`: usa a variável para configurar a região do provider AWS

Os outros arquivos do projeto continuam com a mesma responsabilidade:

- `main.tf`: mantém os blocos `data`
- `output.tf`: mantém os blocos `output`

## 2.4.5 Validar a mudança

Depois de fazer essa alteração, execute:

```bash
tofu plan
```

Se você manteve a mesma região usada anteriormente, a expectativa é que nenhuma mudança de infraestrutura fique pendente.

Isso acontece porque o comportamento do projeto continua o mesmo. A única diferença é que agora a região está parametrizada de forma mais organizada.
