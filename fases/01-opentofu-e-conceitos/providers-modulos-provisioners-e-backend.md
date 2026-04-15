---
layout: default
title: 1.3 Deep Dive nos Blocos do OpenTofu
permalink: /fases/01-opentofu-e-conceitos/providers-modulos-provisioners-e-backend/
prev_title: 1.2 Entendendo o arquivo terraform.tfstate
prev_url: /fases/01-opentofu-e-conceitos/terraform-tfstate/
next_title: 1.4 Destruindo Toda a Infraestrutura
next_url: /fases/01-opentofu-e-conceitos/destruindo-a-infra/
---

# 1.3 Deep Dive nos Blocos do OpenTofu

Este material complementa a fase 1 com quatro conceitos que aparecem cedo em qualquer projeto com OpenTofu.

<blockquote><strong>⚡ Visão rápida:</strong> esta etapa aprofunda os blocos e componentes que mais aparecem em projetos reais: provider, módulo, provisioner e backend.</blockquote>

## 1.3.1 O que é provider

`Provider` é o componente que permite ao OpenTofu conversar com uma nuvem, API ou sistema externo.

É por meio do provider que o OpenTofu consegue criar, consultar, alterar e remover recursos.

Exemplos comuns:

- provider `aws` para recursos da AWS;
- provider `azurerm` para recursos do Azure;
- provider `google` para recursos do Google Cloud;
- outros providers para SaaS, DNS, Kubernetes e muitos outros serviços.

Em termos práticos, sem provider o OpenTofu não sabe como gerenciar o sistema de destino.

Sempre que você adicionar um provider novo, ou alterar a configuração de providers do projeto, execute:

```bash
tofu init -reconfigure
```

Esse passo faz o OpenTofu reconfigurar o diretório de trabalho para o novo conjunto de providers.

## 1.3.2 O que é module

`Module` é uma forma de agrupar recursos relacionados dentro de um diretório.

Todo projeto OpenTofu já começa com um módulo, chamado de `root module`, que é o diretório principal onde você executa os comandos.

Quando você separa código em outros diretórios e passa a reutilizar essa estrutura, você está trabalhando com módulos.

Na prática, essa separação por diretórios é a forma padrão de modularizar projetos em OpenTofu.

Esses módulos podem ser:

- locais, criados dentro do próprio repositório;
- internos, feitos por colegas de trabalho ou pela equipe da empresa;
- externos, publicados pela comunidade em registries públicos ou privados.

Módulos são úteis para reaproveitar padrões como:

- rede;
- grupos de segurança;
- máquinas virtuais;
- bancos de dados;
- conjuntos de permissões.

Mesmo assim, no começo do curso vamos manter a estrutura simples e evitar modularização precoce sem necessidade.

## 1.3.3 O que é provisioner

`Provisioner` é um recurso usado para executar ações adicionais em uma máquina local ou remota durante a criação ou destruição de um recurso.

Exemplos comuns:

- rodar um comando local com `local-exec`;
- copiar arquivos;
- executar comandos remotos em uma instância recém-criada.

Ele existe para casos específicos, mas deve ser usado com cuidado.

De forma geral, provisioners aumentam a complexidade e fogem um pouco do modelo declarativo do OpenTofu, então o ideal é tratá-los como exceção e não como padrão.

## 1.3.4 O que é backend

`Backend` é o mecanismo usado pelo OpenTofu para armazenar o `state`.

De forma simplificada, muita gente trata o backend como o "banco de dados" do projeto no OpenTofu.

O `state` é o registro do que o OpenTofu entende que está sob gerenciamento. Durante `plan` e `apply`, ele usa esse estado junto com a configuração e com a leitura atual da nuvem ou do sistema gerenciado para decidir o que precisa mudar.

Esse backend pode salvar o state em diferentes lugares, por exemplo:

- localmente em arquivo;
- em armazenamento remoto;
- em serviços compartilhados por equipes.

Em projetos com colaboração entre várias pessoas, a recomendação é manter o state em um local externo e compartilhado, porque isso melhora a consistência do trabalho em equipe.

Neste curso, vamos manter tudo localmente por praticidade, para reduzir a complexidade inicial e focar no aprendizado dos conceitos.

## 1.3.5 Referências oficiais do OpenTofu

- documentação geral: https://opentofu.org/docs/
- linguagem do OpenTofu: https://opentofu.org/docs/language/
- configuração de providers: https://opentofu.org/docs/language/providers/configuration/
- visão geral de módulos: https://opentofu.org/docs/language/modules/
- chamada de módulos: https://opentofu.org/docs/language/modules/syntax/
- provisioners: https://opentofu.org/docs/language/resources/provisioners/syntax/
- backend e armazenamento de state: https://opentofu.org/docs/language/state/backends/
- configuração de backend: https://opentofu.org/docs/language/settings/backends/configuration/
