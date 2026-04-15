---
layout: default
title: 5. EC2 com HTTP
permalink: /fases/05-ec2-http/
prev_title: 4.4 Subnets Públicas
prev_url: /fases/04-subnets-dinamicas/subnets-publicas/
next_title: 5.1 Criando a EC2
next_url: /fases/05-ec2-http/criando-a-ec2/
---

# 5. EC2 com HTTP

Nesta fase, vamos sair da camada de rede e subir uma máquina EC2 com um servidor HTTP simples.

<blockquote><strong>⚡ Visão rápida:</strong> o objetivo agora é unir rede, segurança, acesso público e conteúdo web em uma única entrega prática.</blockquote>

Ao final desta fase, o projeto deve ser capaz de:

- criar uma instância EC2;
- associar um IP público a essa máquina;
- liberar acesso HTTP na porta `80`;
- preparar assets HTML locais;
- usar `user_data` para configurar a instância no boot;
- instalar o Apache;
- expor no `output` o IP público para acesso.

Essa fase será separada em três partes:

- `5.1`: criar a EC2, o security group e o output do IP público;
- `5.2`: preparar assets HTTP e ligar esses arquivos ao `user_data`;
- `5.3`: verificar o servidor e acessar a página HTML publicada pela EC2.

Próximo passo:

- [5.1 Criando a EC2](./criando-a-ec2.md)
- [5.2 Enviando Assets HTTP](./enviando-assets-http.md)
- [5.3 Acessando a Página Web](./acessando-a-pagina-web.md)
