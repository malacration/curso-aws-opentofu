---
layout: default
title: 2.6 Entendendo Módulos
permalink: /fases/02-login-na-aws/entendendo-modulos/
prev_title: 2.5 Por Que Usar tfvars e Variáveis
prev_url: /fases/02-login-na-aws/por-que-usar-tfvars-e-variaveis/
next_title: 3. Nuvem Particular (VPC)
next_url: /fases/03-nuvem-particular-vpc/
---

# 2.6 Entendendo Módulos

Nesta etapa, vamos introduzir o conceito de módulos e por que manter módulos bem definidos é tão útil em projetos reais.

<blockquote><strong>🎯 Ideia central:</strong> um módulo é uma unidade reutilizável de infraestrutura com <strong>entrada</strong>, <strong>responsabilidade</strong> e <strong>saída</strong>.</blockquote>

## 2.6.1 O que é um módulo

De forma simples, um módulo é um conjunto de arquivos OpenTofu que representa uma parte reutilizável da infraestrutura.

Em vez de repetir a mesma lógica várias vezes, você pode empacotar essa lógica em um módulo e reutilizá-la em outros projetos ou em outras partes do mesmo ambiente.

<p><strong style="color: var(--link);">📦 Módulo</strong>: um bloco reutilizável de infraestrutura.</p>

## 2.6.2 Por que manter módulos é útil

Manter módulos é muito útil porque permite separar responsabilidades e reaproveitar padrões já prontos.

Por exemplo, você pode ter:

- 🌐 um módulo que cria políticas de rede;
- ☸️ outro módulo que cria um cluster Kubernetes;
- 📈 um módulo que cria um servidor Zabbix para monitoramento;

Esse tipo de separação ajuda porque cada módulo passa a ter um objetivo claro.

## 2.6.3 Reuso entre times

Uma das maiores vantagens de módulos é que eles podem ser entregues para outros times como blocos reutilizáveis.

Ou seja: em vez de entregar apenas documentação solta, você entrega uma unidade de infraestrutura pronta para uso.

Isso permite que outros times consumam o módulo e mantenham um padrão mais consistente de infraestrutura.

Na prática, um módulo pode virar um produto interno da plataforma.

<p><strong style="color: var(--accent);">Efeito prático:</strong> o time de plataforma entrega capacidades reutilizáveis, e não apenas instruções soltas.</p>

## 2.6.4 Módulos ajudam a padronizar

Quando um time centraliza certas soluções em módulos, fica mais fácil garantir:

- ✅ consistência;
- ♻️ reutilização;
- 🧰 menor retrabalho;
- 🔀 menos divergência entre ambientes;
- 🛡️ menos erro manual ao repetir configurações.

Isso vale especialmente para componentes que aparecem o tempo todo, como rede, observabilidade, identidade, monitoramento e bases comuns de infraestrutura.

## 2.6.5 Gancho com variáveis

As variáveis também têm um papel importante aqui.

Quando você declara variáveis em um módulo, está deixando explícito o que aquele módulo precisa para funcionar.

Em outras palavras, as variáveis ajudam a declarar os requisitos de entrada do módulo.

Isso é importante porque um módulo bem definido não depende de adivinhação.

Ele deixa claro:

- 🔹 quais valores precisam ser informados;
- 🔹 quais parâmetros são obrigatórios;
- 🔹 o que pode mudar entre ambientes;
- 🔹 o que aquele módulo espera receber para funcionar corretamente.

## 2.6.6 Pensando no módulo como contrato

Uma boa forma de pensar é esta:

- 🧩 o módulo entrega uma funcionalidade;
- 🧾 as variáveis declaram o que ele precisa para entregar essa funcionalidade.

Por isso, módulo e variável andam muito juntos.

Quanto mais claro estiver esse contrato de entrada, mais fácil será reutilizar o módulo com segurança em diferentes contextos.

Se você vem de programação orientada a objetos, dá para fazer um paralelo útil com construtores.

Aqui a ideia é parecida:

- o módulo representa a implementação da funcionalidade;
- as variáveis representam os parâmetros que precisam ser informados para "instanciar" esse módulo corretamente;
- os outputs representam o que esse módulo devolve para quem o consome depois de pronto.

Então, de forma didática, dá para pensar assim:

- <strong style="color: var(--link);">variáveis</strong> = parâmetros do construtor;
- <strong style="color: var(--accent);">outputs</strong> = valores expostos depois da criação;
- <strong style="color: var(--text);">módulo</strong> = unidade reutilizável que recebe esses parâmetros para funcionar.

Esse paralelo ajuda bastante porque mostra que um bom módulo não é apenas um monte de arquivos.

Ele é uma unidade com responsabilidade clara, entradas bem definidas e saídas previsíveis.

<blockquote>
  <strong>🧠 Comparação rápida com orientação a objetos</strong><br>
  Instanciar um módulo se parece com chamar um construtor: você passa os parâmetros necessários, a implementação é montada internamente, e no final recebe valores úteis para continuar o fluxo.
</blockquote>

## 2.6.7 Exemplo prático com um módulo de PostgreSQL em EC2

Imagine um módulo que cria um banco de dados PostgreSQL rodando em uma instância EC2.

Esse módulo pode ter como entradas:

- 🏗️ um ARN ou identificador da VPC;
- 🕸️ um ARN ou identificador da subnet;
- 💽 um ARN ou identificador do volume EBS.

E pode ter como saídas:

- 📍 um IP interno;
- 🔎 um DNS interno dentro da VPC que chega até o PostgreSQL.

<p><strong style="color: var(--accent);">Entrada do módulo</strong>: define onde e com o que ele vai operar.<br>
<strong style="color: var(--link);">Saída do módulo</strong>: devolve informações úteis para outros blocos consumirem.</p>

## 2.6.8 O que isso mostra na prática

Na prática, esse módulo precisa receber informações sobre em que rede ele vai ficar.

Mas essa decisão não deve ser do módulo.

Essa decisão deve ser de quem está usando o módulo.

Por exemplo:

- 🧪 em homologação, ele pode ser conectado a uma VPC e uma subnet específicas;
- 🚀 em produção, ele pode ser conectado a outra VPC, outra subnet e outro disco.

Ou seja: a rede muda, o disco acoplado também pode mudar, e isso depende do ambiente em que o módulo será instanciado.

## 2.6.9 Separando responsabilidade de implementação e responsabilidade de decisão

A decisão sobre o que conectar no módulo do PostgreSQL é de quem precisa instanciar esse módulo, e não de quem projetou o módulo do PostgreSQL.

Essa é uma forma muito prática de pensar nas variáveis.

As variáveis passam a responsabilidade de decisão sobre o que o módulo vai utilizar para a camada superior.

Então existe uma separação pragmática entre:

- <strong style="color: var(--accent);">o que o módulo faz</strong>;
- <strong style="color: var(--link);">o que ele precisa para conseguir fazer isso</strong>.

Nesse exemplo:

- 🐘 o módulo faz a entrega de um PostgreSQL funcional;
- 🧭 a camada superior decide em qual rede ele ficará, qual subnet será usada e qual disco será acoplado.

Essa separação é valiosa porque permite reutilizar o mesmo módulo em contextos diferentes sem reescrever a implementação interna.

<blockquote>
  <strong>Resumo prático</strong><br>
  O módulo não deveria decidir <em>onde</em> vai rodar. Ele deveria saber <em>como</em> entregar a funcionalidade. A decisão de contexto fica na camada superior.
</blockquote>
