---
layout: default
title: 5.1 Criando a EC2
permalink: /fases/05-ec2-http/criando-a-ec2/
prev_title: 5. EC2 com HTTP
prev_url: /fases/05-ec2-http/
next_title: 5.2 Enviando Assets HTTP
next_url: /fases/05-ec2-http/enviando-assets-http/
---

# 5.1 Criando a EC2

Nesta etapa, vamos criar a base da máquina que servirá a página HTTP.

<blockquote><strong>⚡ Visão rápida:</strong> antes de preparar a página e o Apache, precisamos ter uma instância acessível, com IP público e um security group permitindo HTTP.</blockquote>

## 5.1.1 Security Group para HTTP

Crie um arquivo chamado `ec2.tf`.

No arquivo `ec2.tf`, adicione primeiro um security group que permita acesso HTTP:

```hcl
resource "aws_security_group" "http_server" {
  name        = "${var.vpc_name}-http-server"
  description = "Acesso HTTP para a EC2 do curso"
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

Aqui:

- a porta `80` libera o acesso HTTP;
- o `egress` livre permite que a máquina baixe pacotes e responda a conexões.

Como vamos preparar a máquina com `user_data`, não precisamos liberar a porta `22` nesta fase.

## 5.1.2 Criar a instância

Ainda no arquivo `ec2.tf`, adicione também a instância:

```hcl
resource "aws_instance" "http_server" {
  ami                         = "ami-076742b894530ab1f"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnets[0].id
  vpc_security_group_ids      = [aws_security_group.http_server.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.vpc_name}-${aws_subnet.subnets[0].id}-http-server"
  }
}
```

Nesse exemplo:

- `ami` define a imagem base da instância;
- a EC2 será criada dentro da primeira subnet;
- `associate_public_ip_address = true` garante IP público;
- o security group criado no passo anterior é associado à instância.
- o `ami` e o `instance_type` ficam definidos diretamente no código.
- a `tag Name` concatena o prefixo da VPC com o identificador da subnet usada.
- a preparação da máquina será adicionada no próximo item com `user_data`.

Uma `AMI` é a imagem usada pela AWS para iniciar a EC2.

Na prática, ela define de que base a máquina vai nascer:

- qual sistema operacional será usado;
- quais pacotes e ajustes já existem na imagem;
- qual modelo inicial será clonado para criar a instância.

Neste item, vamos usar esta AMI:

```text
ami-076742b894530ab1f
```

Aqui não vamos usar variáveis para os dados da EC2.

Ou seja: nesta etapa, a ideia é deixar esses valores hardcoded para simplificar o exemplo.

Também não vamos usar `key_name`.

Como a preparação da instância será feita por `user_data`, a máquina não depende de uma chave SSH para o fluxo prático deste curso.

## 5.1.3 Exibir o IP público

No `output.tf`, adicione:

```hcl
output "ec2_public_ip" {
  value = aws_instance.http_server.public_ip
}
```

Esse output é importante porque será o endereço usado para testar o acesso HTTP depois.

## 5.1.4 Aplicar

Agora execute:

```bash
tofu apply
```

A expectativa aqui é criação de infraestrutura real:

- security group;
- instância EC2;
- IP público associado.

## 5.1.5 Resultado esperado

Ao final desta etapa, o projeto já deve mostrar o `ec2_public_ip` no `output`.

Imagem de referência da EC2 em execução:

![EC2 em execução no painel da AWS]({{ '/fases/05-ec2-http/assets/5-1-ec2-em-execucao.png' | relative_url }})

Ainda não esperamos a página HTTP funcionando, porque o Apache e os arquivos HTML serão tratados nas próximas etapas.
