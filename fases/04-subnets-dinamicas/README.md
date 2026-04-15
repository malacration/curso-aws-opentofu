---
layout: default
title: 4. Subnets Dinâmicas
permalink: /fases/04-subnets-dinamicas/
prev_title: 3.4 Contando Zonas de Disponibilidade
prev_url: /fases/03-nuvem-particular-vpc/contando-zonas-de-disponibilidade/
next_title: 4.1 Criando Três Subnets
next_url: /fases/04-subnets-dinamicas/criando-tres-subnets/
---

# 4. Subnets Dinâmicas

Nesta fase, vamos começar a distribuir a rede entre as zonas de disponibilidade da região.

<blockquote><strong>⚡ Visão rápida:</strong> a ideia agora é sair de uma VPC isolada e começar a preparar a base para colocar recursos em mais de uma zona.</blockquote>

Com a lista de zonas de disponibilidade já consultada na fase anterior, o próximo passo é criar três recursos de subnet.

A proposta aqui é simples:

- criar uma subnet na primeira zona;
- criar uma subnet na segunda zona;
- criar uma subnet na terceira zona.

Esse desenho é útil porque permite espalhar carga entre zonas diferentes.

Imagine, por exemplo, que queremos colocar uma cópia de um servidor em cada zona de disponibilidade.

Nesse cenário, cada servidor pode ser conectado a uma subnet diferente, e cada subnet fica associada a uma zona específica.

Isso melhora a organização da rede e prepara o projeto para um desenho mais resiliente.

## 4.2 Ideia central da fase

Nesta fase, o aluno deve entender três pontos:

- 🌐 a VPC pertence à região;
- 📍 cada subnet pertence a uma única zona de disponibilidade;
- 🧱 distribuir subnets entre zonas é a base para distribuir servidores entre essas mesmas zonas.

Mais adiante, essa estrutura permitirá criar recursos de forma mais dinâmica, aproveitando a lista de zonas consultada pelo próprio projeto.

Próximo passo:

- [4.1 Criando Três Subnets](./criando-tres-subnets.md)
- [4.2 CIDR em Variáveis](./cidr-em-variaveis.md)
- [4.3 Recursos Dinâmicos](./recursos-dinamicos.md)
- [4.4 Subnets Públicas](./subnets-publicas.md)
