---
layout: default
title: Fases do Curso
permalink: /fases/
prev_title: 1. Início
prev_url: /
next_title: 1. Introdução e Estrutura do Curso
next_url: /fases/01-opentofu-e-conceitos/
---

# Fases do Curso

Este diretório organiza a evolução prática do curso por fases.

<blockquote><strong>⚡ Visão rápida:</strong> as fases transformam os conceitos do guia principal em exercícios progressivos e verificáveis.</blockquote>

Estrutura inicial:

- `01-opentofu-e-conceitos/`: introdução e estrutura do curso
- `02-login-na-aws/`: login no ambiente AWS usado no curso
- `03-nuvem-particular-vpc/`: introdução à rede privada na nuvem
- `04-subnets-dinamicas/`: distribuição da rede em múltiplas zonas de disponibilidade
- `05-ec2-http/`: instância EC2 com página HTTP simples
- `06-load-balancer/`: Load Balancer na frente das EC2s, sem IP público, três instâncias
- `07-resiliencia/`: hostname na página via metadados da EC2, teste de falha e recuperação com OpenTofu

Orientações gerais:

- ao final de cada etapa, o projeto do aluno deve ficar semelhante ao subdiretório de exemplo da respectiva etapa;
- instruções de credenciais e acessos aos ambientes devem ser obtidas individualmente por cada participante.
