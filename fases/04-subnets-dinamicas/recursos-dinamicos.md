---
layout: default
title: 4.3 Recursos Dinâmicos
permalink: /fases/04-subnets-dinamicas/recursos-dinamicos/
prev_title: 4.2 CIDR em Variáveis
prev_url: /fases/04-subnets-dinamicas/cidr-em-variaveis/
next_title: 4.4 Subnets Públicas
next_url: /fases/04-subnets-dinamicas/subnets-publicas/
---

# 4.3 Recursos Dinâmicos

Nesta etapa, vamos aproveitar um detalhe importante do item anterior: os índices da lista de `subnet_cidr_blocks` combinam com os índices da lista de zonas de disponibilidade.

<blockquote><strong>⚡ Visão rápida:</strong> como o CIDR da subnet e a zona de disponibilidade usam a mesma posição da lista, não precisamos mais declarar três recursos individuais. Podemos repetir um único bloco de forma dinâmica.</blockquote>

## 4.3.1 O que mudou na leitura do problema

No item anterior, a estrutura ficou assim:

- `subnet_cidr_blocks[0]` combina com `data.aws_availability_zones.available.names[0]`;
- `subnet_cidr_blocks[1]` combina com `data.aws_availability_zones.available.names[1]`;
- `subnet_cidr_blocks[2]` combina com `data.aws_availability_zones.available.names[2]`.

Ou seja: existe uma relação direta entre as duas listas.

Quando isso acontece, podemos usar um comando de repetição.

## 4.3.2 Antes e depois

<div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(320px, 1fr)); gap:16px; align-items:start;">
  <div>
    <p><strong style="color: var(--link);">Antes</strong> em <code>subnet.tf</code></p>
    <pre><code class="language-hcl">resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[0]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[1]
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[2]
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[2]}"
  }
}</code></pre>
  </div>
  <div>
    <p><strong style="color: var(--accent);">Depois</strong> em <code>subnet.tf</code></p>
    <pre><code class="language-hcl">resource "aws_subnet" "subnets" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[count.index]}"
  }
}</code></pre>
  </div>
</div>

No bloco novo:

- `count = 3` repete o recurso três vezes;
- `count.index` vale `0`, `1` e `2` em cada repetição;
- o mesmo índice é usado para escolher o CIDR e a zona correspondente;
- a `tag Name` também acompanha o mesmo índice.

## 4.3.3 Ajustar o `subnet.tf`

Agora substitua os três blocos antigos por um bloco único como este:

```hcl
resource "aws_subnet" "subnets" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.vpc_name}-${data.aws_availability_zones.available.names[count.index]}"
  }
}
```

## 4.3.4 Ajustar o `output.tf`

Como o recurso agora virou uma coleção, o `output` também deve ser atualizado.

Troque a lista manual por:

```hcl
output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}
```

Aqui o `[*].id` coleta o `id` de todas as instâncias criadas dinamicamente.

## 4.3.5 O que acontece no `apply`

Existe um detalhe importante aqui.

Antes, o projeto tinha três recursos diretamente referenciados:

- `aws_subnet.subnet_a`
- `aws_subnet.subnet_b`
- `aws_subnet.subnet_c`

Agora, o projeto passa a ter uma coleção de recursos:

- `aws_subnet.subnets[0]`
- `aws_subnet.subnets[1]`
- `aws_subnet.subnets[2]`

Essas duas coisas não são equivalentes para o banco de dados do OpenTofu.

Essa é a ideia central:

- antes, existiam `3 recursos` com nomes próprios;
- agora, existe `1 coleção` que contém `3 recursos`.

Isso parece parecido olhando a infraestrutura, mas não é a mesma coisa olhando a referência lógica salva no `state`.

Em outras palavras:

- uma coisa é ter três recursos nomeados individualmente;
- outra coisa é ter uma lista com três itens.

Por causa disso, ao fazer essa troca direta no código, o OpenTofu tende a entender que as referências antigas deixaram de existir e que novas referências apareceram no projeto.

Na prática, isso normalmente leva o plano a destruir e recriar as subnets.

## 4.3.6 Aplicar

Agora execute:

```bash
tofu apply
```

Aqui a expectativa muda.

Ao contrário do item anterior, agora o plano tende a mostrar destruição e recriação, justamente porque a referência salva no banco de dados do OpenTofu foi modificada.

Ou seja: a infraestrutura pode até continuar representando "três subnets", mas o endereço lógico desses recursos no projeto deixou de ser o mesmo.

Imagem de referência do terminal mostrando destruição e criação:

![Plano mostrando destruição e criação de recursos após a mudança para recurso dinâmico]({{ '/fases/04-subnets-dinamicas/assets/4-3-destroy-create-terminal.png' | relative_url }})

<blockquote>
  <strong>⚠️ Observação prática</strong><br>
  Esse <code>apply</code> pode falhar. Em alguns casos, a AWS ainda não liberou completamente aquela faixa de IP de subnet dentro da VPC no momento em que a recriação acontece. Então pode ocorrer um cenário assim: na primeira execução a subnet antiga é destruída, mas a nova falha ao ser criada porque algum mecanismo de segurança ou validação da AWS impediu a criação naquele instante. Se você rodar o plano novamente logo depois, pode perceber que ele já não mostra mais a destruição daquela subnet antiga, porque ela já foi removida na primeira execução; o que permanece pendente é apenas a criação do novo recurso.
</blockquote>

## 4.3.7 Resultado esperado

Na prática, esta etapa mostra quatro ideias:

- 🔁 quando a estrutura repete o mesmo padrão, um comando de repetição simplifica o código;
- 📚 listas combinadas por índice permitem usar `count.index`;
- 🧱 um bloco dinâmico reduz duplicação;
- 💾 mudar a referência lógica dos recursos altera a forma como o OpenTofu enxerga o que já existe no `state`.
