---
layout: default
title: 1.4 Destruindo Toda a Infraestrutura
permalink: /fases/01-opentofu-e-conceitos/destruindo-a-infra/
prev_title: 1.3 Deep Dive nos Blocos do OpenTofu
prev_url: /fases/01-opentofu-e-conceitos/providers-modulos-provisioners-e-backend/
next_title: 2. Conectando Tofu a AWS
next_url: /fases/02-login-na-aws/
---

# 1.4 Destruindo Toda a Infraestrutura

Nesta etapa, vamos aprender duas formas de destruir infraestrutura no OpenTofu.

<blockquote><strong>⚡ Visão rápida:</strong> esta etapa fecha a fase 1 mostrando como voltar o projeto para um estado limpo tanto por comando quanto por remoção de código.</blockquote>

## 1.4.1 Destruir tudo com `tofu destroy`

Se você digitar o comando abaixo, o OpenTofu vai destruir toda a infraestrutura que estiver sob gerenciamento naquele projeto:

```bash
tofu destroy
```

Esse comando é útil quando alguns problemas aparecem e tornam o projeto ou o módulo instável.

Nesses casos, pode ser mais simples destruir tudo e construir novamente do que tentar corrigir um estado já inconsistente.

## 1.4.2 Faça o teste: destruir e recriar

Neste momento, execute:

```bash
tofu destroy
```

Depois disso, recrie o que foi destruído executando novamente:

```bash
tofu apply
```

Esse exercício mostra que o ciclo de vida da infraestrutura pode ser controlado por código: destruir, recriar e voltar ao estado esperado.

## 1.4.3 Outra forma de destruir: remover o recurso do arquivo

Outra forma de destruir infraestrutura é remover o bloco de recurso do arquivo `.tf` e depois aplicar o plano.

Isso funciona porque o plano é a diferença entre:

- o que está escrito no seu arquivo;
- as referências salvas no banco de dados do projeto, ou seja, no `terraform.tfstate`;
- e os valores consultados pelo provider no sistema ou na nuvem gerenciada.

Se o recurso existe no state, mas não existe mais no arquivo, o OpenTofu entende que ele precisa ser removido.

## 1.4.4 Removendo o `null_resource` pelo código

Abra o `main.tf` e remova:

- o bloco `resource "null_resource" "exemplo" { ... }`;
- o `output "null_resource_id"`, porque essa referência deixa de existir quando o recurso é removido.

Depois disso, execute:

```bash
tofu plan
tofu apply
```

Nesse caso, a destruição não acontece porque você rodou `tofu destroy`, mas porque o código deixou de declarar aquele recurso.

## 1.4.5 Estado final esperado

Ao final desta etapa, o arquivo `main.tf` deve estar totalmente em branco.

Esse fechamento é importante porque ele encerra a fase 1 com o projeto limpo, pronto para a próxima fase.
