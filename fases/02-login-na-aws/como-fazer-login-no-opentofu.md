---
layout: default
title: 2.1 Como Fazer Login no OpenTofu
permalink: /fases/02-login-na-aws/como-fazer-login-no-opentofu/
prev_title: 2. Conectando Tofu a AWS
prev_url: /fases/02-login-na-aws/
next_title: 2.3 Organizando o Projeto
next_url: /fases/02-login-na-aws/separando-o-projeto-em-varios-arquivos/
---

# 2.1 Como Fazer Login no OpenTofu

<blockquote><strong>⚡ Visão rápida:</strong> o OpenTofu não faz login próprio na AWS; ele reutiliza o contexto autenticado da AWS CLI para consultar e operar recursos.</blockquote>

## 2.1.1 Como funciona o login no OpenTofu

O OpenTofu não tem um comando próprio de login na AWS.

Na prática, ele reutiliza as credenciais que já foram carregadas pela `AWS CLI`, por variáveis de ambiente, perfil local ou outro método suportado pelo provider da AWS.

Então, neste curso, o "login no OpenTofu" significa:

1. autenticar pela `AWS CLI`;
2. validar que a sessão está funcionando;
3. executar o OpenTofu usando esse mesmo contexto autenticado.

## 2.1.2 Fazer login pela AWS CLI

Se você estiver em Linux nativo:

```bash
aws login --profile treinamento
```

Se você estiver no `WSL`:

```bash
aws login --remote --profile treinamento
```

Quando a AWS CLI pedir a região, informe:

```bash
sa-east-1
```

## 2.1.3 Validar a sessão autenticada

Depois do login, confirme a identidade carregada:

```bash
aws sts get-caller-identity --profile treinamento
```

Se quiser simplificar os próximos comandos da sessão atual:

```bash
export AWS_PROFILE=treinamento
```

Se o perfil já estiver exportado, a validação também pode ser feita assim:

```bash
aws sts get-caller-identity
```

## 2.1.4 Criar o bloco `provider "aws"`

No diretório do projeto, edite o arquivo `main.tf` com o bloco do provider:

```hcl
provider "aws" {
  region = "sa-east-1"
}
```

Esse bloco diz ao OpenTofu que ele vai conversar com a AWS e que a região desejada para este exemplo é `sa-east-1`.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/providers/configuration">Abrir documentação do bloco <code>provider</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs">Abrir documentação do provider AWS</a>
</blockquote>

## 2.1.5 Criar o bloco `data "aws_caller_identity"`

Agora adicione o bloco abaixo:

```hcl
data "aws_caller_identity" "current" {}
```

Esse `data` source consulta quem é a identidade autenticada atual na AWS.

É por meio dele que vamos capturar informações como o `account_id` da conta conectada.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/block/data">Abrir documentação do bloco <code>data</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity">Abrir documentação do data source <code>aws_caller_identity</code></a>
</blockquote>

## 2.1.6 Criar o bloco `data "aws_region"`

Depois disso, adicione:

```hcl
data "aws_region" "current" {}
```

Esse `data` source consulta a região atualmente usada pelo provider da AWS.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/block/data">Abrir documentação do bloco <code>data</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region">Abrir documentação do data source <code>aws_region</code></a>
</blockquote>

## 2.1.7 Criar os blocos de `output`

Agora adicione os outputs:

```hcl
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "regiao_atual" {
  value = data.aws_region.current.id
}
```

Esses blocos servem para exibir no final do `apply`:

- o `account_id` da conta autenticada;
- a região atual consultada no provider.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/values/outputs">Abrir documentação do bloco <code>output</code></a>
</blockquote>

## 2.1.8 Exemplo completo de `main.tf`

Ao final, o arquivo `main.tf` deve ficar assim:

```hcl
provider "aws" {
  region = "sa-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "regiao_atual" {
  value = data.aws_region.current.id
}
```

## 2.1.9 Inicializar o projeto

Como esse arquivo introduz um provider novo, execute:

```bash
tofu init -reconfigure
```

Esse passo baixa e prepara o provider `aws` no diretório atual.

## 2.1.10 Executar plano e aplicação

Depois da inicialização, execute:

```bash
tofu plan
```

Se o plano estiver correto, aplique:

```bash
tofu apply
```

## 2.1.11 Resultado esperado

Ao final do `apply`, o OpenTofu deve conseguir exibir por `output`:

- o `account_id` da conta autenticada;
- a região atual, como `sa-east-1`.

Se isso aparecer corretamente, significa que o OpenTofu conseguiu reutilizar o login da `AWS CLI` e se conectar à AWS com sucesso.
