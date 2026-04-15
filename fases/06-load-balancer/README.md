---
layout: default
title: 6. Load Balancer
permalink: /fases/06-load-balancer/
prev_title: 5.3 Acessando a Página Web
prev_url: /fases/05-ec2-http/acessando-a-pagina-web/
next_title: 6.1 Criando o Load Balancer
next_url: /fases/06-load-balancer/criando-o-load-balancer/
---

# 6. Load Balancer

Nesta fase, vamos colocar um Load Balancer na frente da EC2 e evoluir a arquitetura em três etapas.

<blockquote><strong>⚡ Visão rápida:</strong> até agora a instância EC2 era acessada diretamente pelo IP público. Nesta fase, o Load Balancer passa a ser o único ponto de entrada, e a EC2 deixa de ter IP público. Ao final, escalamos para três instâncias — uma por zona de disponibilidade.</blockquote>

## O que é um Application Load Balancer?

Um **Application Load Balancer (ALB)** é um serviço gerenciado da AWS que atua na **camada 7 (HTTP/HTTPS)** do modelo OSI.

Ele recebe requisições da internet e as distribui entre as instâncias registradas, de acordo com regras configuráveis. Como é um serviço **gerenciado**, a AWS cuida da disponibilidade, escalabilidade e manutenção da infraestrutura do próprio balanceador.

## Os objetos do Load Balancer

A imagem abaixo é da documentação oficial da AWS e ilustra como os componentes se relacionam:

![Arquitetura de componentes do ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/images/component_architecture.png)

*Fonte: [Documentação oficial AWS — Application Load Balancers](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)*

### Load Balancer

O **Load Balancer** é o ponto único de entrada para o tráfego vindo da internet.

- Ele é associado a subnets em diferentes zonas de disponibilidade;
- Possui um **DNS exclusivo** gerado pela AWS — esse endereço não muda mesmo que os IPs internos variem;
- Não tem IP fixo: a AWS gerencia os IPs internamente e expõe apenas o DNS.

### Listener

O **Listener** é a regra que define em qual porta o Load Balancer escuta e o que fazer com as requisições recebidas.

- Cada Listener é configurado com um protocolo (`HTTP`, `HTTPS`) e uma porta (`80`, `443`);
- Contém uma ou mais **rules (regras)** que determinam para qual Target Group o tráfego é encaminhado;
- A **default rule** é obrigatória e é aplicada quando nenhuma outra regra casa com a requisição.

Neste projeto usamos um Listener simples: porta 80, protocolo HTTP, encaminhando tudo para um único Target Group.

### Target Group

O **Target Group** é a lista de destinos que vão receber o tráfego distribuído pelo Load Balancer.

- Os destinos podem ser instâncias EC2, endereços IP ou funções Lambda;
- Cada Target Group tem um **health check** configurado: o ALB faz requisições periódicas para verificar se cada instância está saudável antes de enviar tráfego real;
- Uma instância só começa a receber tráfego depois de passar pelo número mínimo de health checks configurado (`healthy_threshold`).

### Target Group Attachment

O **Target Group Attachment** é o vínculo entre uma instância específica e um Target Group.

- Sem esse registro, o ALB não sabe que a instância existe;
- O registro inclui o ID da instância e a porta que ela deve usar para receber o tráfego.

## O que vamos construir

```
Internet
    │
    ▼
[ ALB ] ── porta 80 ── Listener
    │
    └── Target Group
            │
            ├── EC2 [0] — subnet zona 1
            ├── EC2 [1] — subnet zona 2
            └── EC2 [2] — subnet zona 3
```

## Etapas desta fase

- `6.1`: criar o Load Balancer e apontar para a EC2 existente;
- `6.2`: remover o IP público da EC2 — o ALB passa a ser o único acesso;
- `6.3`: escalar para três instâncias usando `count`.

Próximo passo:

- [6.1 Criando o Load Balancer](./criando-o-load-balancer.md)
- [6.2 Removendo o IP Público da EC2](./removendo-ip-publico.md)
- [6.3 Escalando as Instâncias](./escalando-instancias.md)
