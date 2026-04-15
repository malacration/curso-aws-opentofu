---
layout: default
title: 2.3 Organizando o Projeto
permalink: /fases/02-login-na-aws/separando-o-projeto-em-varios-arquivos/
prev_title: 2.1 Como Fazer Login no OpenTofu
prev_url: /fases/02-login-na-aws/como-fazer-login-no-opentofu/
next_title: 2.4 Usando Variáveis para a Região
next_url: /fases/02-login-na-aws/usando-variaveis-para-a-regiao/
---

# 2.3 Organizando o Projeto

Nesta etapa, vamos separar o projeto em arquivos diferentes para melhorar a organização.

<blockquote><strong>⚡ Visão rápida:</strong> aqui o comportamento do projeto continua o mesmo; o ganho está na clareza e na manutenção do código.</blockquote>

O OpenTofu continua lendo todos os arquivos `.tf` do diretório como um único projeto, mas a divisão em arquivos ajuda muito na leitura e na manutenção.

## 2.3.1 Arquivos esperados

Neste momento, o projeto deve passar a ter estes arquivos:

- `provider.tf`
- `main.tf`
- `output.tf`

## 2.3.2 O que vai em `provider.tf`

O bloco `provider "aws"` não deve mais ficar no `main.tf`.

Agora ele deve ser movido para o arquivo `provider.tf`.

A ideia aqui é simples: tudo que diz respeito à conexão do OpenTofu com a AWS deve ficar concentrado nesse arquivo.

Então, no `provider.tf`, deixe a configuração do provider, como a região usada no projeto.

## 2.3.3 O que vai em `main.tf`

O `main.tf` deve permanecer com a parte principal da lógica do projeto.

Neste exemplo, isso significa manter no `main.tf` os blocos `data` que consultam informações da AWS já autenticada.

Então os blocos `data "aws_caller_identity" "current"` e `data "aws_region" "current"` permanecem no `main.tf`.

Mais para frente, esse também tende a ser o arquivo onde ficam recursos e outras partes centrais da configuração.

## 2.3.4 O que vai em `output.tf`

Os blocos de `output` também não precisam continuar no `main.tf`.

Agora eles devem ser movidos para o arquivo `output.tf`.

Ou seja: tudo que serve para exibir valores no final do `apply` deve ficar concentrado nesse arquivo.

Neste caso, mova para `output.tf` os outputs que mostram o `account_id` e a `regiao_atual`.

## 2.3.5 Estrutura final do projeto

Ao final, a estrutura deve ficar assim:

- `provider.tf`: contém apenas o bloco do provider AWS
- `main.tf`: mantém os blocos `data` que consultam a identidade e a região
- `output.tf`: contém os blocos `output` que exibem essas informações

Perceba que não estamos mudando o comportamento do projeto.

Estamos apenas reorganizando o que já foi criado no passo anterior.

## 2.3.6 Validar a separação

Depois de separar os arquivos, execute:

```bash
tofu plan
```

Se estiver tudo correto, o OpenTofu continuará entendendo o projeto normalmente, porque essa divisão é apenas organizacional.

Ou seja: depois da organização, nenhuma mudança deve ficar pendente para aplicação.

Na prática, o `plan` não deve indicar alteração de infraestrutura, porque nada foi modificado no comportamento do projeto.

A única vantagem obtida aqui foi a organização do código.
