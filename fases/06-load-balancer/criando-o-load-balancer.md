---
layout: default
title: 6.1 Criando o Load Balancer
permalink: /fases/06-load-balancer/criando-o-load-balancer/
prev_title: 6. Load Balancer
prev_url: /fases/06-load-balancer/
next_title: 6.2 Removendo o IP Público da EC2
next_url: /fases/06-load-balancer/removendo-ip-publico/
---

# 6.1 Criando o Load Balancer

Nesta etapa, vamos criar um Application Load Balancer e apontá-lo para a EC2 existente.

<blockquote><strong>⚡ Visão rápida:</strong> o Load Balancer recebe as requisições da internet e as repassa para as instâncias registradas. Ele expõe um DNS próprio — exclusivo do serviço gerenciado pela AWS — que substitui o IP público da EC2 como ponto de acesso.</blockquote>

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group">Abrir documentação do recurso <code>aws_security_group</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb">Abrir documentação do recurso <code>aws_lb</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group">Abrir documentação do recurso <code>aws_lb_target_group</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener">Abrir documentação do recurso <code>aws_lb_listener</code></a>
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment">Abrir documentação do recurso <code>aws_lb_target_group_attachment</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/values/outputs">Abrir documentação do bloco <code>output</code></a>
</blockquote>

## 6.1.1 O que é um Application Load Balancer?

Um **Application Load Balancer (ALB)** é um serviço gerenciado da AWS que distribui o tráfego HTTP entre uma ou mais instâncias.

Ele é composto por três partes:

- **Load Balancer**: o recurso principal, associado a subnets e a um security group;
- **Target Group**: a lista de instâncias que vão receber o tráfego;
- **Listener**: a regra que define em qual porta o ALB escuta e para qual Target Group encaminha.

## 6.1.2 Criar o arquivo `lb.tf`

Crie um arquivo `lb.tf` no projeto.

### Security Group do ALB

O ALB precisa de um security group próprio, separado do security group das EC2s:

```hcl
resource "aws_security_group" "alb" {
  name        = "${var.vpc_name}-alb"
  description = "Acesso HTTP ao Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Load Balancer

O atributo `subnets` aceita uma lista de IDs. Existem duas formas de passá-los.

**Passando uma a uma** — útil para deixar explícito quais subnets estão sendo usadas:

```hcl
resource "aws_lb" "main" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [
    aws_subnet.subnets[0].id,
    aws_subnet.subnets[1].id,
    aws_subnet.subnets[2].id,
  ]

  tags = {
    Name = "${var.vpc_name}-alb"
  }
}
```

**Passando a lista completa** — mais conciso, usando o operador `[*]` que coleta o atributo `id` de todos os itens da coleção:

```hcl
resource "aws_lb" "main" {
  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.subnets[*].id

  tags = {
    Name = "${var.vpc_name}-alb"
  }
}
```

<blockquote>
  <strong>💡 Observação</strong><br>
  As duas formas produzem o mesmo resultado. A diferença é que a lista manual precisa ser atualizada manualmente se o número de subnets mudar, enquanto <code>[*].id</code> acompanha automaticamente qualquer alteração no <code>count</code> do recurso <code>aws_subnet.subnets</code>. Para este projeto, onde o número de subnets é fixo, ambas funcionam igualmente bem.
</blockquote>

O ALB exige pelo menos duas subnets em zonas de disponibilidade diferentes — requisito obrigatório para que o serviço seja considerado de alta disponibilidade pela AWS.

### Target Group

O Target Group define como o ALB vai verificar a saúde das instâncias e para onde vai encaminhar o tráfego:

```hcl
resource "aws_lb_target_group" "http" {
  name     = "${var.vpc_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
  }
}
```

O `health_check` faz requisições GET para `/` a cada 15 segundos. Depois de 2 respostas saudáveis, a instância é marcada como `healthy` e começa a receber tráfego.

### Listener

O Listener define que o ALB escuta na porta 80 e encaminha para o Target Group:

```hcl
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
```

### Registrar a EC2 no Target Group

```hcl
resource "aws_lb_target_group_attachment" "http" {
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.http_server.id
  port             = 80
}
```

## 6.1.3 Exibir o DNS do Load Balancer

Adicione ao `output.tf`:

```hcl
output "alb_dns" {
  value = aws_lb.main.dns_name
}
```

## 6.1.4 Aplicar

Execute:

```bash
tofu apply
```

O plano deve mostrar a criação do security group do ALB, do próprio ALB, do Target Group, do Listener e do registro da EC2.

## 6.1.5 Acessar pelo DNS do Load Balancer

Ao final do `apply`, o output `alb_dns` exibe o endereço:

```bash
tofu output alb_dns
```

Abra no navegador:

```
http://SEU_ALB_DNS
```

<blockquote>
  <strong>⏳ Aguarde o health check</strong><br>
  O ALB só começa a encaminhar tráfego depois que a instância passa pelo health check. Isso pode levar até 30 segundos após o <code>apply</code>. Se o navegador retornar erro 502 ou 503, aguarde e recarregue.
</blockquote>

## 6.1.6 O DNS do ALB é exclusivo do serviço gerenciado

O endereço exibido no output tem um formato parecido com:

```
andrew-42-alb-1234567890.sa-east-1.elb.amazonaws.com
```

Esse DNS é gerado automaticamente pela AWS no momento em que o ALB é criado.

Duas características importantes:

- **Não é um IP fixo**: o ALB pode mudar de IPs internamente sem aviso — por isso a AWS fornece um DNS, não um IP;
- **Exclusivo do serviço**: esse endereço só existe enquanto o ALB existir. Se o recurso for destruído e recriado, um novo DNS será gerado.

Em projetos reais, esse DNS costuma ser associado a um domínio próprio via `CNAME` no Route 53 ou em outro serviço de DNS.
