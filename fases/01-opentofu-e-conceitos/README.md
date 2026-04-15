---
layout: default
title: 1. Introdução e Estrutura do Curso
permalink: /fases/01-opentofu-e-conceitos/
prev_title: Fases do Curso
prev_url: /fases/
next_title: 1.1 Primeiro plano
next_url: /fases/01-opentofu-e-conceitos/primeiro-plano/
---

# 1. Introdução e Estrutura do Curso

<blockquote><strong>⚡ Visão rápida:</strong> esta fase apresenta a estrutura mínima do projeto OpenTofu e prepara o aluno para ler, alterar e organizar arquivos `.tf` com segurança.</blockquote>

Estrutura:

- `assets/`: imagens, diagramas e material visual
- `projeto/`: resultado do projeto ao final da fase.

Próximos passos:

- [1.1 Primeiro plano](./primeiro-plano.md)
- [1.2 Entendendo o arquivo terraform.tfstate](./terraform-tfstate.md)
- [1.3 Deep Dive nos Blocos do OpenTofu](./providers-modulos-provisioners-e-backend.md)
- [1.4 Destruindo Toda a Infraestrutura](./destruindo-a-infra.md)

Orientações da fase:

- ao final de cada etapa, o projeto do aluno deve ficar semelhante ao subdiretório de exemplo correspondente;
- antes de executar mudanças de infraestrutura, o OpenTofu lê e combina todos os arquivos `.tf` do diretório como um único projeto;
- a separação em arquivos como `main.tf`, `variables.tf` e `outputs.tf` existe para organização humana;
- tecnicamente, nada impede definir variáveis em um arquivo como `windson.tf` ou até em `outputs.tf`, mas isso piora a legibilidade e adiciona complexidade desnecessária;
- vamos manter o princípio `KISS - Keep It Simple, Stupid` e preferir nomes e divisões simples e previsíveis;
- instruções de credenciais e acessos aos ambientes devem ser obtidas individualmente por cada participante.
