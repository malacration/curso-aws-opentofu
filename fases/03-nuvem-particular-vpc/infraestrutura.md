---
layout: default
title: 3.1 Infraestrutura
permalink: /fases/03-nuvem-particular-vpc/infraestrutura/
prev_title: 3. Nuvem Particular (VPC)
prev_url: /fases/03-nuvem-particular-vpc/
next_title: 3.2 Primeira VPC
next_url: /fases/03-nuvem-particular-vpc/primeira-vpc/
---

# 3.1 Infraestrutura

Nesta etapa, vamos olhar a infraestrutura da AWS do ponto de vista de rede: região, zonas de disponibilidade, VPC e subnets.

<blockquote><strong>⚡ Visão rápida:</strong> antes de criar recursos de rede, é importante entender em que parte do mapa global eles existirão e como essa estrutura é organizada dentro de uma região.</blockquote>

## 3.1.1 Região

Uma região da AWS é uma área geográfica separada.

Na prática, quando você escolhe uma região, está decidindo em qual parte do mundo seus recursos serão criados.

Isso influencia latência, disponibilidade de serviços, soberania de dados e proximidade com usuários ou sistemas externos.

![Mapa global simplificado das regiões da AWS]({{ '/fases/03-nuvem-particular-vpc/assets/aws-regioes-globais.png' | relative_url }})

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial da AWS:
  <br>
  <a href="https://aws.amazon.com/about-aws/global-infrastructure/">Abrir visão geral da infraestrutura global da AWS</a>
  <br>
  <a href="https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions-availability-zones.html">Abrir documentação de regiões e zonas de disponibilidade</a>
</blockquote>

## 3.1.2 Zonas de disponibilidade dentro de uma região

Cada região da AWS possui múltiplas zonas de disponibilidade.

As zonas de disponibilidade são locais isolados dentro da região, usados para aumentar disponibilidade e resiliência.

A AWS informa oficialmente que cada região possui no mínimo três zonas de disponibilidade.

## 3.1.3 Região contendo suas zonas de disponibilidade

Algumas regiões podem ter mais do que três zonas de disponibilidade.

![Exemplo didático de uma região com as zonas de disponibilidade]({{ '/fases/03-nuvem-particular-vpc/assets/regiao-cinco-zonas.png' | relative_url }})

## 3.1.4 Região São Paulo

Na documentação oficial da AWS, a região São Paulo, `sa-east-1`, aparece com três zonas de disponibilidade.

![Região São Paulo com três zonas de disponibilidade]({{ '/fases/03-nuvem-particular-vpc/assets/regiao-sao-paulo-tres-zonas.svg' | relative_url }})

Para esta região, a documentação lista:

- `sae1-az1`
- `sae1-az2`
- `sae1-az3`

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial da AWS:
  <br>
  <a href="https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-availability-zones.html">Abrir documentação de Availability Zones da AWS</a>
</blockquote>

## 3.1.5 Subnets e zona de disponibilidade

Uma subnet sempre pertence a uma única zona de disponibilidade.

Ela não pode atravessar duas zonas ao mesmo tempo.

Isso é importante porque, ao criar subnets, você está distribuindo partes da sua rede entre zonas diferentes da mesma região.

A documentação da AWS afirma explicitamente que cada subnet deve residir inteiramente dentro de uma Availability Zone.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial da AWS:
  <br>
  <a href="https://docs.aws.amazon.com/vpc/latest/userguide/vpc-subnet-basics.html">Abrir documentação de fundamentos de VPC e subnets</a>
  <br>
  <a href="https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html">Abrir documentação de configuração de subnets na VPC</a>
</blockquote>

## 3.1.6 Estrutura completa: região, VPC, zonas e subnets

A imagem abaixo junta esses conceitos em uma única visão:

![Estrutura de região, VPC, zonas de disponibilidade e subnets]({{ '/fases/03-nuvem-particular-vpc/assets/regiao-vpc-subnets-zonas.svg' | relative_url }})

O raciocínio é:

- a região é o limite geográfico principal;
- a VPC vive dentro da região;
- a VPC pode ter recursos distribuídos entre várias zonas de disponibilidade;
- cada subnet fica associada obrigatoriamente a uma única zona.

Essa organização é a base sobre a qual instâncias, bancos, balanceadores e outros serviços passam a depender.
