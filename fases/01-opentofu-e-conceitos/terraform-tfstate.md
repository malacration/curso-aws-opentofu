---
layout: default
title: 1.2 Entendendo o arquivo terraform.tfstate
permalink: /fases/01-opentofu-e-conceitos/terraform-tfstate/
prev_title: 1.1 Primeiro plano
prev_url: /fases/01-opentofu-e-conceitos/primeiro-plano/
next_title: 1.3 Deep Dive nos Blocos do OpenTofu
next_url: /fases/01-opentofu-e-conceitos/providers-modulos-provisioners-e-backend/
---

# 1.2 Entendendo o arquivo terraform.tfstate

Depois do primeiro `apply`, o OpenTofu cria um arquivo chamado `terraform.tfstate`.

<blockquote><strong>⚡ Visão rápida:</strong> aqui o foco é entender como o state registra o que já foi aplicado e como ele influencia o `plan` e o `apply`.</blockquote>

## 1.2.1 O que é o `terraform.tfstate`

Esse arquivo é o `state` local do projeto.

De forma simplificada, ele funciona como o banco de dados do plano e da infraestrutura que o OpenTofu está acompanhando.

É nele que o OpenTofu salva o que já foi aplicado, para depois comparar esse registro com o código `.tf` e com o ambiente real.

## 1.2.2 Criar mais um `output`

Abra o arquivo `main.tf` e adicione mais um bloco de `output`:

```hcl
output "segundo_plano" {
  value = "meu segundo bloco"
}
```

Ao final, o arquivo ficará assim:

```hcl
output "primeiro_plano" {
  value = "meu primeiro bloco"
}

output "segundo_plano" {
  value = "meu segundo bloco"
}
```

## 1.2.3 Executar `tofu plan` novamente

Depois da alteração, execute:

```bash
tofu plan
```

Agora o OpenTofu vai comparar:

- o código atual do `main.tf`;
- o conteúdo salvo no `terraform.tfstate`;
- e o que precisa ser atualizado no estado do projeto.

O resultado esperado deve indicar a inclusão de mais um `output`.

Depois de revisar o plano, o próximo passo é executar `tofu apply` para salvar essa mudança no state.

## 1.2.4 Executar `tofu apply` novamente

Para aplicar essa mudança, execute:

```bash
tofu apply
```

Esse novo `apply` vai atualizar o `terraform.tfstate` e salvar essa nova saída no estado local do projeto.

## 1.2.5 Como ler o resumo de recursos do `plan`

Quando o plano envolve recursos gerenciados, o OpenTofu mostra no resumo final uma linha com a quantidade de recursos que serão adicionados, modificados e destruídos.

<p><strong style="color: var(--accent);">Resources: 0 added, 0 changed, 0 destroyed.</strong></p>

Essa linha é importante porque ela resume o impacto do plano antes do `apply`.

## 1.2.6 O que é um recurso

Um recurso pode ser uma infinidade de coisas, por exemplo:

- uma máquina virtual;
- uma entrada no DNS;
- uma política de firewall;
- um servidor virtual em um proxy reverso;
- um bucket;
- uma regra de rota;
- um banco de dados.

Em resumo, recurso é qualquer objeto que o OpenTofu esteja gerenciando.

## 1.2.7 Quando uma mudança vira `changed` e quando vira `destroyed` + `added`

Nem toda alteração aparece como `1 changed`.

Às vezes o plano vai mostrar `1 added` e `1 destroyed`, porque aquele recurso não suporta modificação direta, ou porque um dos atributos alterados define a identidade ou o ciclo de vida do recurso.

Exemplo conceitual:

- se você mudar uma entrada DNS de `windson.com` para `gadelha.com`, em muitos casos o recurso antigo será destruído e outro será criado com o novo valor;
- se você adicionar uma tag em uma máquina virtual, normalmente o recurso será apenas atualizado, sem recriação.

Por isso, ler o resumo do plano é importante: ele mostra se a mudança é uma simples atualização ou se haverá substituição do recurso.

## 1.2.8 Exemplo com `null_resource`: criação e recriação

O `null_resource` é um bom exemplo para demonstrar criação e substituição.

Para usar esse exemplo, adicione ao arquivo main.tf:

```hcl
terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "null_resource" "exemplo" {
  triggers = {
    nome = "windson.com"
  }
}
```

Como esse exemplo adiciona um provider novo ao projeto, antes do próximo `plan` execute:

```bash
tofu init -reconfigure
```

Sempre que você adicionar ou alterar providers, o recomendado é executar `tofu init -reconfigure` para que o OpenTofu reconfigure o diretório de trabalho e baixe o que for necessário para o novo contexto do projeto.

Na primeira execução, o plano deve indicar criação do recurso:

<p><strong style="color: var(--accent);">Resources: 1 added, 0 changed, 0 destroyed.</strong></p>

Depois de conferir esse plano, execute `tofu apply` para criar o recurso e salvar essa informação no `terraform.tfstate`.

Se depois você alterar o valor de `nome` para `gadelha.com`, o `null_resource` será substituído:

```hcl
resource "null_resource" "exemplo" {
  triggers = {
    nome = "gadelha.com"
  }
}
```

Nesse caso, o plano tende a mostrar algo assim:

<p><strong style="color: var(--accent);">Resources: 1 added, 0 changed, 1 destroyed.</strong></p>

Isso acontece porque a mudança em `triggers` força recriação do `null_resource`.

Depois de revisar esse segundo plano, execute `tofu apply` novamente para destruir o recurso antigo, criar o novo e atualizar o `terraform.tfstate`.

* Sempre que você executar `tofu plan` e decidir seguir com a mudança, o passo seguinte é `tofu apply`.

## 1.2.9 Output também pode capturar valores de recursos

`Output` não serve apenas para exibir texto fixo.

Ele também pode capturar atributos de recursos criados pelo OpenTofu e mostrar esses valores no final do `apply`.

Com o `null_resource`, por exemplo, você pode criar mais um `output` para expor o identificador interno do recurso:

```hcl
output "null_resource_id" {
  value = null_resource.exemplo.id
}
```

Esse valor só fica disponível depois que o recurso existe de fato.

Antes da criação, o OpenTofu ainda não conhece esse identificador final. Depois do `apply`, ele passa a conhecer esse valor, salva isso no `terraform.tfstate` e consegue exibi-lo no output.

Depois de adicionar esse bloco, execute:

```bash
tofu plan
tofu apply
```

## 1.2.10 Exemplo com recurso real

Em um recurso real de nuvem, a ideia é a mesma.

Por exemplo, em uma máquina virtual da AWS, seria possível capturar o ID interno da instância depois da criação do objeto.

Esse tipo de valor é útil porque normalmente ele só existe depois que o recurso foi criado pela plataforma.

## 1.2.11 Encadeando mudanças e permissões

Isso é muito útil para encadear mudanças entre recursos.

Imagine que você tenha:

- uma lista de máquinas virtuais;
- um usuário;
- e uma política que libera acesso desse usuário apenas para máquinas específicas.

Nesse cenário, você pode capturar os IDs das máquinas criadas e usar esses IDs na política associada ao usuário.

Assim, a parte lógica de permissão fica encadeada com a infraestrutura real.

No futuro, se essas máquinas precisarem ser refeitas, por exemplo em uma mudança de tecnologia de `x86_64` para `AArch64`, a parte lógica de permissão já estará encadeada e continuará garantida com os novos IDs gerados pelo OpenTofu.

Isso evita retrabalho e reduz regressões de funcionalidade.

Em mudanças reais, é muito difícil lembrar manualmente todos os requisitos associados, como:

- acessos;
- rotinas;
- verificações;
- vínculos entre recursos.

Quando esses relacionamentos estão modelados no código, o OpenTofu ajuda a manter tudo consistente mesmo quando a infraestrutura muda.
