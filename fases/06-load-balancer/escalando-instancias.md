---
layout: default
title: 6.3 Escalando as Instâncias
permalink: /fases/06-load-balancer/escalando-instancias/
prev_title: 6.2 Removendo o IP Público da EC2
prev_url: /fases/06-load-balancer/removendo-ip-publico/
next_title: 7. Resiliência e Alta Disponibilidade
next_url: /fases/07-resiliencia/
---

# 6.3 Escalando as Instâncias

Nesta etapa, vamos subir mais duas instâncias EC2 — uma por subnet privada — e registrá-las automaticamente no Load Balancer.

<blockquote><strong>⚡ Visão rápida:</strong> hoje o projeto tem uma única instância apontada diretamente pelo Target Group. Vamos substituir esse recurso individual por uma coleção usando <code>count</code>, o mesmo recurso de repetição visto na fase 4.</blockquote>

## 6.3.1 Estado atual do projeto

Ao chegar neste item, o `ec2.tf` tem uma instância única:

```hcl
resource "aws_instance" "http_server" {
  ami                         = "ami-076742b894530ab1f"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.http_server.id]
  subnet_id                   = aws_subnet.private_subnets[0].id
  associate_public_ip_address = false

  tags = {
    Name          = "${var.vpc_name}-${aws_subnet.subnets[0].id}-http-server"
    IndexHtmlHash = filesha256("${path.module}/assets/http/index.html")
  }

  user_data = templatefile("${path.module}/assets/http/user-data.sh.tftpl", {
    index_html = file("${path.module}/assets/http/index.html")
  })
  user_data_replace_on_change = true
}
```

E o `lb.tf` tem um único registro no Target Group:

```hcl
resource "aws_lb_target_group_attachment" "http" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.http_server.id
  port             = 80
}
```

## 6.3.2 Adicionar `count` à instância

No `ec2.tf`, adicione `count = 3` e substitua o índice fixo `[0]` por `count.index` no `subnet_id` e na tag `Name`:

```hcl
resource "aws_instance" "http_server" {
  count                       = 3
  ami                         = "ami-076742b894530ab1f"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.http_server.id]
  subnet_id                   = aws_subnet.private_subnets[count.index].id
  associate_public_ip_address = false

  tags = {
    Name          = "${var.vpc_name}-http-server-${count.index}"
    IndexHtmlHash = filesha256("${path.module}/assets/http/index.html")
  }

  user_data = templatefile("${path.module}/assets/http/user-data.sh.tftpl", {
    index_html = file("${path.module}/assets/http/index.html")
  })
  user_data_replace_on_change = true
}
```

Com `count = 3` e `subnet_id = aws_subnet.private_subnets[count.index].id`:

- instância `[0]` → subnet privada da zona 1;
- instância `[1]` → subnet privada da zona 2;
- instância `[2]` → subnet privada da zona 3.

## 6.3.3 Atualizar o Target Group Attachment

No `lb.tf`, o registro atual aponta para `aws_instance.http_server.id` — uma referência direta a um recurso individual. Precisamos substituir por uma coleção com `count`:

```hcl
resource "aws_lb_target_group_attachment" "http" {
  count            = 3
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.http_server[count.index].id
  port             = 80
}
```

O mesmo `count.index` conecta cada instância ao seu registro correspondente no Target Group.

## 6.3.4 Remover o output `ec2_public_ip`

O `output.tf` ainda tem este bloco criado na fase 5:

```hcl
output "ec2_public_ip" {
  value = aws_instance.http_server.public_ip
}
```

Esse output tem dois problemas agora:

- a referência `aws_instance.http_server.public_ip` era válida para um recurso individual — com `count`, ela se torna ambígua e o OpenTofu vai recusar o plano com erro;
- mesmo que fosse corrigida para `aws_instance.http_server[*].public_ip`, as instâncias não têm mais IP público desde o item 6.2.

Remova o bloco inteiro do `output.tf`. O acesso agora é feito exclusivamente pelo DNS do ALB, que já está exposto no output `alb_dns`.

## 6.3.6 O que acontece no `apply`

Esta mudança tem um detalhe importante parecido com o que aconteceu na fase 4 com as subnets.

Antes, o projeto tinha um recurso diretamente referenciado:

- `aws_instance.http_server`
- `aws_lb_target_group_attachment.http`

Depois, passa a ter coleções:

- `aws_instance.http_server[0]`, `[1]`, `[2]`
- `aws_lb_target_group_attachment.http[0]`, `[1]`, `[2]`

Para o OpenTofu, a referência lógica mudou. Por isso, o plano tende a mostrar:

- destruição da instância e do attachment antigos (referência individual);
- criação de três instâncias e três attachments novos (referência indexada).

Execute:

```bash
tofu apply
```

<blockquote>
  <strong>⚠️ Observação prática</strong><br>
  Durante o apply, haverá um breve período em que o Target Group fica sem instâncias registradas. O ALB retornará erro 503 até as novas instâncias passarem pelo health check. Aguarde cerca de 1 a 2 minutos após o apply para o serviço se estabilizar.
</blockquote>

## 6.3.7 Testar o serviço

Acesse pelo DNS do ALB:

```bash
curl http://$(tofu output -raw alb_dns)
```

O ALB distribui as requisições entre as três instâncias automaticamente. Todas respondem com o mesmo `index.html`, então o conteúdo exibido será sempre o mesmo independente de qual instância recebeu a requisição.

<blockquote>
  <strong>⏳ Aguarde o health check das novas instâncias</strong><br>
  Com <code>interval = 15</code> e <code>healthy_threshold = 2</code>, leva cerca de 30 segundos após o boot para cada instância começar a receber tráfego.
</blockquote>

## 6.3.8 Resultado esperado

Ao final desta fase, o projeto terá:

- 🌐 um Application Load Balancer com DNS exclusivo;
- 🔒 EC2s sem IP público — acessíveis apenas pelo ALB;
- 🖥️ três instâncias EC2, uma por zona de disponibilidade;
- 🔁 distribuição de tráfego automática entre as instâncias;
- 📋 health check garantindo que só instâncias saudáveis recebem tráfego.
