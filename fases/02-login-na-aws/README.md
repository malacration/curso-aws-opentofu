---
layout: default
title: 2. Conectando Tofu a AWS
permalink: /fases/02-login-na-aws/
prev_title: 1.4 Destruindo Toda a Infraestrutura
prev_url: /fases/01-opentofu-e-conceitos/destruindo-a-infra/
next_title: 2.1 Como Fazer Login no OpenTofu
next_url: /fases/02-login-na-aws/como-fazer-login-no-opentofu/
---

# 2. Conectando Tofu a AWS

Esta fase organiza a preparação de acesso ao ambiente AWS usado no curso.

<blockquote><strong>⚡ Visão rápida:</strong> esta fase conecta autenticação da AWS CLI, provider AWS, outputs, variáveis e organização do projeto em uma sequência prática.</blockquote>

O objetivo prático aqui é capturar o contexto de autenticação da `AWS CLI`, reutilizar esse login no OpenTofu e conseguir expor por `output` informações como o `account_id` da conta conectada e a região em uso.

Material de apoio já ligado à trilha principal do curso:

- [4. Instalando a AWS CLI e Fazendo Login](../../04-aws-cli-e-login.md)

Objetivos sugeridos para esta fase:

- realizar login com o perfil `treinamento`;
- validar identidade e origem das credenciais carregadas;
- reaproveitar no OpenTofu os tokens e credenciais carregados pela `AWS CLI`;
- expor por `output` o `account_id` e a região da sessão conectada.

Estrutura:

- `assets/`: imagens, diagramas e material visual
- `projeto/`: resultado esperado ao final da fase

Orientações da fase:

- no `WSL`, o fluxo de login deve usar `aws login --remote`;
- a região padrão do treinamento neste curso é `sa-east-1`;
- sempre valide o login com `aws sts get-caller-identity`;
- o OpenTofu pode reutilizar o contexto autenticado da `AWS CLI` sem precisar de um login separado;
- ao final da fase, o ideal é conseguir provar por `output` em qual conta e em qual região você está operando;
- se necessário, use `export AWS_PROFILE=treinamento` para simplificar os comandos da sessão atual.

Próximo passo:

- [2.1 Como Fazer Login no OpenTofu](./como-fazer-login-no-opentofu.md)
- [2.3 Organizando o Projeto](./separando-o-projeto-em-varios-arquivos.md)
- [2.4 Usando Variáveis para a Região](./usando-variaveis-para-a-regiao.md)
- [2.5 Por Que Usar tfvars e Variáveis](./por-que-usar-tfvars-e-variaveis.md)
- [2.6 Entendendo Módulos](./entendendo-modulos.md)
