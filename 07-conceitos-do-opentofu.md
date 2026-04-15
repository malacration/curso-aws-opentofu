---
layout: default
title: 7. Conceitos do OpenTofu
permalink: /conceitos-opentofu/
prev_title: 6. Diretório do Projeto e VS Code
prev_url: /diretorio-e-vscode/
next_title: 1. Introdução e Estrutura do Curso
next_url: /fases/01-opentofu-e-conceitos/
---

# 7. Conceitos do OpenTofu

Depois da preparação do ambiente, este é o ponto em que o curso entra nos conceitos.

<blockquote><strong>⚡ Visão rápida:</strong> esta página consolida a base conceitual que sustenta as fases práticas seguintes.</blockquote>

Se quiser seguir para a parte prática correspondente, vá para [1. Introdução e Estrutura do Curso]({{ '/fases/01-opentofu-e-conceitos/' | relative_url }}).

## 7.1 O que é infraestrutura como código

Infraestrutura como código, ou `IaC`, é a prática de definir infraestrutura em arquivos versionáveis em vez de criar tudo manualmente no painel da nuvem.

Com isso, rede, máquinas, permissões e serviços passam a ser descritos em código e aplicados de forma controlada.

## 7.2 O que é Terraform

Terraform é uma ferramenta de `IaC` que usa arquivos declarativos para criar, alterar e remover infraestrutura.

Neste curso, ele aparece como referência conceitual da mesma categoria de ferramenta que estamos usando com OpenTofu.

## 7.3 O que é OpenTofu

OpenTofu é uma ferramenta de infraestrutura como código. Ela permite descrever infraestrutura em arquivos declarativos e depois criar, atualizar ou remover recursos de forma controlada.

## 7.4 Por que ele existe

OpenTofu é um fork do Terraform. Ele surgiu para manter uma alternativa aberta e orientada pela comunidade depois da mudança de licença do Terraform.

## 7.5 Casos de uso

OpenTofu pode ser usado para:

- criar VPC, subnets, rotas e security groups;
- criar instâncias, bancos, buckets e outros serviços de nuvem;
- padronizar ambientes de desenvolvimento, teste e produção;
- reproduzir a mesma estrutura em contas ou regiões diferentes.

## 7.6 Benefícios

Os principais benefícios são:

- repetibilidade;
- rastreabilidade;
- padronização;
- redução de erro manual;
- facilidade para revisar mudanças antes de aplicar.

## 7.7 CaC vs IaC

`CaC`, ou Configuration as Code, foca na configuração de sistemas e aplicações depois que a infraestrutura já existe.

`IaC` foca na criação e gestão da própria infraestrutura.

Em resumo:

- `IaC`: cria e organiza rede, servidores, serviços e recursos;
- `CaC`: configura o que roda dentro desses recursos.

## 7.8 Como isso aparece no curso

Ao longo das aulas, você vai usar OpenTofu para:

- definir infraestrutura em arquivos `.tf`;
- executar comandos como `init`, `plan`, `apply` e `destroy`;
- organizar variáveis, outputs e recursos;
- entender o papel do state.

## 7.9 Como o OpenTofu lê os arquivos `.tf`

Antes de aplicar uma mudança de infraestrutura, o OpenTofu lê todos os arquivos `.tf` do diretório atual e entende esse conjunto como um único projeto.

Na prática, isso significa que a separação em arquivos é uma convenção de organização para humanos, e não um isolamento real entre partes do projeto.

Por isso, é comum usar nomes como `main.tf`, `variables.tf` e `outputs.tf`, porque eles deixam a intenção do código mais clara.

Tecnicamente, nada impede colocar variáveis em um arquivo chamado `windson.tf` ou até misturar variáveis, recursos e outputs no mesmo arquivo.

Mesmo sendo possível, esse tipo de escolha tende a piorar a leitura, aumentar a complexidade desnecessária e dificultar manutenção.

Neste curso, vamos seguir o princípio `KISS`: manter a estrutura simples, previsível e fácil de entender.

## 7.10 O que você deve dominar neste ponto

- o que é infraestrutura como código;
- o que é Terraform no contexto de IaC;
- o que o OpenTofu faz;
- a diferença entre descrever infraestrutura e criar tudo manualmente;
- a ideia de que o código passa a representar o ambiente.

## 7.11 Próximos conceitos sugeridos para a fase

- arquivos `main.tf`, `variables.tf` e `outputs.tf`;
- providers, resources e data sources;
- ciclo `init`, `plan`, `apply` e `destroy`;
- state.

## 7.12 Como validar cada etapa prática

- ao final de cada etapa, o projeto do aluno deve ficar semelhante ao subdiretório de exemplo correspondente;
- instruções de credenciais e acessos aos ambientes devem ser obtidas individualmente por cada participante.
