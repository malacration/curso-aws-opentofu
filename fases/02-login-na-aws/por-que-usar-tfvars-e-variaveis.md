---
layout: default
title: 2.5 Por Que Usar tfvars e Variáveis
permalink: /fases/02-login-na-aws/por-que-usar-tfvars-e-variaveis/
prev_title: 2.4 Usando Variáveis para a Região
prev_url: /fases/02-login-na-aws/usando-variaveis-para-a-regiao/
next_title: 2.6 Entendendo Módulos
next_url: /fases/02-login-na-aws/entendendo-modulos/
---

# 2.5 Por Que Usar tfvars e Variáveis

Nesta etapa, vamos entender por que separar valores em variáveis e em arquivos `.tfvars` é tão útil em projetos reais.

<blockquote><strong>⚡ Visão rápida:</strong> variáveis ajudam tanto na segurança e no versionamento quanto na clareza dos requisitos de entrada do projeto.</blockquote>

## 2.5.1 Organização é só o começo

Separar a configuração em `variables.tf` e `terraform.tfvars` ajuda na organização, mas a principal vantagem não é apenas essa.

Em projetos reais, esse padrão também ajuda a proteger informações, facilitar compartilhamento do código e deixar os requisitos do projeto mais claros.

## 2.5.2 O problema de valores sensíveis no código

Em muitas situações, os valores colocados em variáveis não são apenas nomes ou regiões.

Frequentemente, variáveis guardam informações como:

- tokens;
- chaves;
- senhas;
- nomes internos;
- identificadores de ambientes;
- valores específicos de cliente, conta ou organização.

Quando esse tipo de informação fica misturado diretamente no código principal do projeto, o risco de exposição aumenta.

## 2.5.3 Por que o `terraform.tfvars` ajuda

Ao deixar a declaração da variável em `variables.tf` e o valor dela em `terraform.tfvars`, você separa:

- a estrutura do projeto;
- dos valores concretos usados em um ambiente específico.

Isso é muito útil porque, ao compartilhar o projeto em um repositório Git, você pode colocar o arquivo `terraform.tfvars` no `.gitignore`.

Assim, o repositório continua contendo a estrutura do projeto, mas evita expor informações sensíveis que não deveriam ser publicadas ou compartilhadas com toda a equipe.

Em outras palavras:

- o código continua versionado;
- os valores sensíveis ficam fora do repositório;
- o projeto se torna mais seguro para compartilhamento.

## 2.5.4 O papel do `.gitignore`

Quando um arquivo como `terraform.tfvars` pode conter informação sensível, uma prática comum é adicioná-lo ao `.gitignore`.

Isso evita que ele seja enviado para o repositório por engano.

Esse cuidado é especialmente importante quando o projeto é compartilhado com outras pessoas, publicado em GitHub ou usado como base para automação.

## 2.5.5 Variáveis também definem os requisitos do projeto

Declarar variáveis não serve apenas para receber valores.

Também é uma forma de documentar o que o projeto precisa para funcionar.

Quando alguém lê um `variables.tf`, essa pessoa consegue entender quais entradas precisam ser fornecidas para que o projeto seja executado corretamente.

Na prática, as variáveis ajudam a responder perguntas como:

- de qual região o projeto precisa;
- quais nomes devem ser informados;
- quais credenciais, identificadores ou parâmetros são obrigatórios;
- quais valores podem mudar de um ambiente para outro.

## 2.5.6 Pensando como contrato de entrada

Uma boa forma de enxergar variáveis é tratá-las como um contrato de entrada do projeto.

Ou seja: elas deixam claro quais são os requisitos mínimos para que aquele conjunto de arquivos funcione.

Isso melhora:

- a leitura;
- a manutenção;
- a reutilização;
- e a previsibilidade do comportamento do projeto.

## 2.5.7 Resultado prático

Quando você separa variáveis e valores corretamente:

- o projeto fica mais organizado;
- o compartilhamento em Git fica mais seguro;
- os requisitos do projeto ficam explícitos;
- e a troca de contexto entre ambientes se torna mais simples.

Esse padrão parece pequeno no começo, mas faz muita diferença conforme o projeto cresce.
