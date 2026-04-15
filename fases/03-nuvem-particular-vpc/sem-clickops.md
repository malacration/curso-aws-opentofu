---
layout: default
title: 3.3 Sem ClickOps
permalink: /fases/03-nuvem-particular-vpc/sem-clickops/
prev_title: 3.2 Primeira VPC
prev_url: /fases/03-nuvem-particular-vpc/primeira-vpc/
next_title: 3.4 Contando Zonas de Disponibilidade
next_url: /fases/03-nuvem-particular-vpc/contando-zonas-de-disponibilidade/
---

# 3.3 Sem ClickOps

Nesta etapa, vamos reforçar uma regra prática importante: evitar criar ou alterar recursos manualmente no console da AWS quando eles já estão sendo controlados pelo OpenTofu.

<blockquote><strong>⚡ Visão rápida:</strong> se a infraestrutura está no código, a mudança deve nascer no código. O console serve para inspeção, validação e troubleshooting, não como fonte principal de configuração.</blockquote>

## 3.3.1 O que é ClickOps

ClickOps é o hábito de criar, alterar ou apagar recursos clicando diretamente no console do provedor.

No começo isso pode parecer mais rápido, mas passa a gerar inconsistência quando o projeto já está sendo mantido por OpenTofu.

## 3.3.2 Por que isso vira problema

Quando você muda algo manualmente no console, o código deixa de representar exatamente o que existe na nuvem.

Na prática, isso costuma gerar problemas como:

- ⚠️ divergência entre o que está no `main.tf` e o que realmente existe;
- ♻️ dificuldade de reproduzir o ambiente;
- 🔎 perda de rastreabilidade;
- 🧰 retrabalho em correções futuras;
- 🧨 risco de sobrescrever mudanças sem perceber no próximo `plan` ou `apply`.

## 3.3.3 O papel do código como fonte de verdade

Se a VPC foi criada pelo OpenTofu, o caminho correto para evoluir essa VPC é continuar alterando os arquivos do projeto.

Foi exatamente isso que aconteceu no item anterior:

- 🏗️ primeiro a VPC foi criada pelo código;
- 🏷️ depois a `tag Name` foi adicionada também pelo código.

Esse fluxo é importante porque mantém o histórico de decisão dentro do projeto, e não espalhado em cliques difíceis de rastrear.

## 3.3.4 Quando olhar o console faz sentido

Abrir o console da AWS continua sendo útil.

Mas o uso mais saudável do console neste curso é:

- 👀 verificar se o recurso apareceu;
- 🏷️ conferir atributos visuais;
- 🔍 inspecionar o estado atual;
- 🛠️ investigar problemas.

Ou seja: o console ajuda a observar, mas a configuração principal continua sendo feita no OpenTofu.

## 3.3.5 Provocando o acidente no console

Agora vamos provocar esse problema de propósito para observar o comportamento do OpenTofu.

Com a VPC já criada e já nomeada pelo projeto:

- 🌐 abra o console da AWS;
- 📍 encontre a VPC criada no item anterior;
- ✏️ edite manualmente as tags;
- 🗑️ remova a `tag Name`;
- 💾 salve a alteração.

Esse é um exemplo de acidente controlado.

A mudança foi feita diretamente no console, e não no projeto local.

Ou seja: a nuvem agora passou a ter um valor diferente do que o código declara.

Imagem de referência deste momento:

![Remoção manual da tag Name no console da AWS]({{ '/fases/03-nuvem-particular-vpc/assets/3-3-clickops-removendo-tag-name.png' | relative_url }})

Depois disso, volte para o projeto e rode:

```bash
tofu plan
```

O OpenTofu vai consultar o estado atual do recurso na AWS, comparar com o que está salvo no `state` e com o que o código declara, e detectar que existe uma diferença.

Nesse cenário, o plano volta a mostrar uma alteração pendente, porque a `tag Name` deveria existir segundo o projeto.

<blockquote>
  <strong>🧭 Leitura correta do cenário</strong><br>
  O problema não está no código local. O problema foi a alteração manual feita no console, que gerou desvio entre a infraestrutura real e a definição do projeto.
</blockquote>

Depois, execute:

```bash
tofu apply
```

Com isso, a configuração tende a ser restaurada e a VPC volta para o estado definido no código.

Esse exemplo é importante porque mostra uma ideia central:

- 🚫 a mudança feita no ClickOps não deveria ter acontecido;
- 📘 o projeto local continua sendo a referência correta;
- 🔎 o `plan` ajuda a detectar esse desvio;
- 🔁 o `apply` ajuda a recolocar a infraestrutura no estado esperado.

## 3.3.6 Regra prática

Se o recurso está sob gestão do OpenTofu:

- ❌ não crie manualmente no console;
- ❌ não altere manualmente no console;
- ✅ prefira sempre ajustar o código, rodar `tofu plan` e depois `tofu apply`.

Essa disciplina evita drift, reduz erro humano e torna o ambiente muito mais previsível.
