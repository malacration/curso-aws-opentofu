---
layout: default
title: 7. Conceitos do OpenTofu
permalink: /conceitos-opentofu/
prev_title: 6. Diretório do Projeto e VS Code
prev_url: /diretorio-e-vscode/
optional_title: 8. Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 7. Conceitos do OpenTofu

Depois da preparação do ambiente, este é o ponto em que o curso entra nos conceitos.

## 7.1 O que é OpenTofu

OpenTofu é uma ferramenta de infraestrutura como código. Ela permite descrever infraestrutura em arquivos declarativos e depois criar, atualizar ou remover recursos de forma controlada.

## 7.2 Por que ele existe

OpenTofu é um fork do Terraform. Ele surgiu para manter uma alternativa aberta e orientada pela comunidade depois da mudança de licença do Terraform.

## 7.3 Como isso aparece no curso

Ao longo das aulas, você vai usar OpenTofu para:

- definir infraestrutura em arquivos `.tf`;
- executar comandos como `init`, `plan`, `apply` e `destroy`;
- organizar variáveis, outputs e recursos;
- entender o papel do state.

## 7.4 Convenção desta fase conceitual

Quando o material mencionar Terraform em contexto conceitual, leia como OpenTofu.

## 7.5 O que você deve dominar neste ponto

- o que é infraestrutura como código;
- o que o OpenTofu faz;
- a diferença entre descrever infraestrutura e criar tudo manualmente;
- a ideia de que o código passa a representar o ambiente.

## 7.6 Próximos conceitos sugeridos para a fase

- arquivos `main.tf`, `variables.tf` e `outputs.tf`;
- providers, resources e data sources;
- ciclo `init`, `plan`, `apply` e `destroy`;
- state.

## 7.7 Como validar cada etapa prática

- ao final de cada etapa, o projeto do aluno deve ficar semelhante ao subdiretório de exemplo correspondente;
- instruções de credenciais e acessos aos ambientes devem ser obtidas individualmente por cada participante.
