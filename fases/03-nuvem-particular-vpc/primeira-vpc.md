---
layout: default
title: 3.2 Primeira VPC
permalink: /fases/03-nuvem-particular-vpc/primeira-vpc/
prev_title: 3.1 Infraestrutura
prev_url: /fases/03-nuvem-particular-vpc/infraestrutura/
next_title: 3.3 Sem ClickOps
next_url: /fases/03-nuvem-particular-vpc/sem-clickops/
---

# 3.2 Primeira VPC

Nesta etapa, vamos continuar o projeto para criar a primeira `VPC` na AWS.

<blockquote><strong>⚡ Visão rápida:</strong> agora o projeto deixa de apenas consultar dados da AWS e passa a criar um recurso real de rede.</blockquote>

A ideia aqui é usar a estrutura que já foi montada nas fases anteriores e adicionar no `main.tf` um bloco de recurso para a VPC.

Vamos fazer isso em duas etapas:

- primeiro criar a VPC;
- depois modificar a infraestrutura para adicionar o nome por variável.

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc">Abrir documentação do recurso <code>aws_vpc</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/values/outputs">Abrir documentação do bloco <code>output</code></a>
</blockquote>

## 3.2.1 Criando a VPC

Nesta etapa, a mudança principal acontece no `main.tf`, porque é nele que vamos adicionar o primeiro recurso de infraestrutura da fase.

Adicione ao `main.tf` um bloco como este:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

Esse bloco instrui o OpenTofu a criar uma VPC com a rede `10.0.0.0/16`.

Depois disso, ajuste também o `output.tf`.

Além dos outputs que já existem no projeto, adicione mais um output para exibir o identificador interno da VPC criada.

No valor `aws_vpc.main.id`:

- `aws_vpc`: é o tipo do recurso;
- `main`: é o nome lógico que demos para esse recurso no projeto;
- `id`: é o atributo interno gerado pela AWS depois da criação da VPC.

O bloco deve ficar assim:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

Isso é útil porque o `id` da VPC só existe depois da criação do recurso.

Mais para frente, esse valor poderá ser usado para encadear subnets, tabelas de rota, internet gateway, security groups e outros recursos de rede.

Se o projeto já está inicializado e o provider AWS não mudou, você pode seguir direto para o plano:

```bash
tofu plan
```

O esperado é que o plano mostre a criação da nova VPC.

<p><strong style="color: #22c55e;">Resources: 1 added, 0 changed, 0 destroyed.</strong></p>

Imagem de referência do plano no terminal:

![Plano no terminal mostrando a criação da VPC]({{ '/fases/03-nuvem-particular-vpc/assets/3-2-vcp-imagem-plan terminal.png' | relative_url }})

Depois de revisar o plano, aplique:

```bash
tofu apply
```

Ao confirmar, o OpenTofu vai criar a VPC na AWS e registrar essa criação no arquivo de `state`.

Ou seja: além de existir na nuvem, a VPC também passa a existir como referência salva no projeto.

Como resultado desse primeiro `apply`, você deve conseguir ver a VPC criada na AWS ainda sem a `tag Name`.

![VPC criada após o primeiro apply ainda sem tag Name]({{ '/fases/03-nuvem-particular-vpc/assets/3-2-vcp-imagem-no-tag.png' | relative_url }})

## 3.2.2 Adicionar o nome da VPC com variável

Agora vamos modificar a infraestrutura já existente.

Em vez de escrever o nome diretamente dentro do recurso, a ideia é declarar uma variável para isso.

No `variables.tf`, adicione:

```hcl
variable "vpc_name" {
  type = string
}
```

No `terraform.tfvars`, adicione um valor para essa variável:

```hcl
vpc_name = "andrew-42"
```

Se o curso inteiro estiver sendo feito dentro da mesma conta AWS por vários alunos, esse padrão ajuda bastante.

Nesse cenário, o ideal é cada aluno usar algo como `nome-matricula` para evitar confusão visual e facilitar a identificação da VPC dentro da conta compartilhada.

## 3.2.3 Modificar o recurso existente

Agora volte ao `main.tf` e ajuste o recurso que já existe.

Neste passo, vamos adicionar a `tag Name` a essa VPC.

Altere o bloco `aws_vpc.main` para que ele fique assim:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}
```

O ponto principal aqui é simples: o recurso já existe, então estamos apenas alterando um atributo.

Trecho adicionado ao recurso:

<pre style="border: 1px solid rgba(34, 197, 94, 0.35); background: rgba(34, 197, 94, 0.08); color: #22c55e; border-radius: 14px; padding: 16px; overflow-x: auto;"><code>tags = {
  Name = var.vpc_name
}</code></pre>

Depois disso, execute:

```bash
tofu plan
```

O plano deve indicar algo nesta linha:

<p><strong style="color: #22c55e;">Resources: 0 added, 1 changed, 0 destroyed.</strong></p>

Isso mostra que adicionar a `tag Name` nessa VPC não exige destruir e recriar o recurso.

Depois de revisar o resultado, aplique:

```bash
tofu apply
```

Esse `apply` atualiza a VPC já criada e grava essa nova condição no `state`.

Depois dessa alteração, a VPC já deve aparecer nomeada no console da AWS.

![VPC nomeada após a adição da tag Name]({{ '/fases/03-nuvem-particular-vpc/assets/3-2-vcp-imagem-nomeada.png' | relative_url }})

É importante entender o papel dessa `tag Name`.

Ela ajuda muito na identificação visual do recurso no console da AWS, mas ela não é um identificador único.

Na prática, seria possível ter várias VPCs com o mesmo valor na `tag Name`.

O identificador único real da AWS continua sendo o `vpc_id`, que é exatamente o valor que estamos exibindo no `output`.

## 3.2.4 Resultado esperado

No final desse processo, você terá passado por dois momentos diferentes:

- criação da VPC;
- modificação da VPC já existente.

Isso ajuda a perceber na prática a diferença entre:

- <strong style="color: var(--accent);">criar</strong> infraestrutura nova;
- <strong style="color: var(--link);">modificar</strong> infraestrutura existente.

## 3.2.5 Verificando na AWS

Depois do segundo `apply`, você já pode abrir o console da AWS e verificar a VPC visualmente.

Nesse momento, você deve conseguir ver:

- a VPC criada na região configurada no projeto;
- o `id` da VPC;
- a `tag Name` definida com o valor da variável.

Na prática, isso confirma algumas coisas importantes:

- o provider AWS está funcionando;
- o OpenTofu conseguiu criar um recurso real;
- o OpenTofu conseguiu modificar esse mesmo recurso sem recriá-lo;
- a VPC agora já pode servir como base para as próximas etapas de rede.
