---
layout: default
title: 1.1 Primeiro plano
permalink: /fases/01-opentofu-e-conceitos/primeiro-plano/
prev_title: 1. Introdução e Estrutura do Curso
prev_url: /fases/01-opentofu-e-conceitos/
next_title: 1.2 Entendendo o arquivo terraform.tfstate
next_url: /fases/01-opentofu-e-conceitos/terraform-tfstate/
---

# 1.1 Primeiro plano

Neste passo, vamos criar o primeiro arquivo do projeto OpenTofu.

<blockquote><strong>⚡ Visão rápida:</strong> este é o primeiro contato prático com `main.tf`, `plan`, `apply` e o ciclo básico de trabalho no OpenTofu.</blockquote>

## 1.1.1 Criar o arquivo `main.tf`

No diretório do projeto, crie um arquivo chamado `main.tf`.

## 1.1.2 Adicionar o primeiro bloco

Dentro do arquivo `main.tf`, adicione um bloco de `output` com a saída `meu primeiro bloco`:

```hcl
output "primeiro_plano" {
  value = "meu primeiro bloco"
}
```

## 1.1.3 Objetivo deste passo

Esse exemplo serve apenas para praticar a estrutura básica de um arquivo `.tf` e entender como um bloco é declarado no OpenTofu.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/values/outputs">Abrir documentação do bloco <code>output</code></a>
</blockquote>

## 1.1.4 Executar `tofu init`

Depois de criar o arquivo, execute:

```bash
tofu init
```

Esse comando inicializa o projeto OpenTofu no diretório atual.

Na prática, ele prepara o diretório de trabalho para que os próximos comandos funcionem corretamente.

## 1.1.5 Executar `tofu plan`

Depois da inicialização, execute:

```bash
tofu plan
```

Esse comando analisa os arquivos `.tf`, compara com o `state` atual e mostra o que o OpenTofu pretende fazer.

Neste primeiro exemplo, como ainda não existe infraestrutura salva no state, a saída do `plan` deve ser algo próximo de:

```text
Changes to Outputs:
  + primeiro_plano = "meu primeiro bloco"

You can apply this plan to save these new output values to the OpenTofu state, without changing any real infrastructure.
```

## 1.1.6 Executar `tofu apply`

Para aplicar esse plano, execute:

```bash
tofu apply
```

O OpenTofu vai mostrar o plano novamente e pedir confirmação.

Para continuar, digite:

```text
yes
```

Esse passo vai aplicar o plano e salvar o primeiro estado da nossa infraestrutura no `state` local.
