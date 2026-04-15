---
layout: default
title: 7. Resiliência e Alta Disponibilidade
permalink: /fases/07-resiliencia/
prev_title: 6.3 Escalando as Instâncias
prev_url: /fases/06-load-balancer/escalando-instancias/
next_title: 7.1 Exibindo o Hostname na Página
next_url: /fases/07-resiliencia/exibindo-o-hostname/
---

# 7. Resiliência e Alta Disponibilidade

Nesta fase, vamos colocar em prática dois conceitos fundamentais de arquiteturas distribuídas: **observabilidade** e **resiliência**.

<blockquote><strong>⚡ Visão rápida:</strong> com três instâncias servindo a mesma página, não há como saber pelo browser qual máquina respondeu. Vamos resolver isso com o hostname — e depois destruir uma instância manualmente para ver se o serviço sobrevive.</blockquote>

## O problema

Com o Load Balancer distribuindo o tráfego entre três instâncias, toda requisição pode chegar a uma máquina diferente. A página HTML é idêntica nas três — não há como distinguir quem respondeu.

Isso cria dois desafios práticos:

- **Observabilidade**: como saber qual instância está servindo cada requisição?
- **Resiliência**: o que acontece se uma instância falhar? O serviço para?

## O que vamos fazer

```
Usuário → ALB → instância [0]  →  página: "Servido por: i-0abc123..."
               → instância [1]  →  página: "Servido por: i-0def456..."
               → instância [2]  →  página: "Servido por: i-0ghi789..."
```

- `7.1`: modificar o `user_data` para injetar o ID da instância na página HTML no boot;
- `7.2`: destruir uma instância manualmente pelo painel da AWS e verificar que o serviço continua, depois usar o OpenTofu para recuperar a infraestrutura.

Próximo passo:

- [7.1 Exibindo o Hostname na Página](./exibindo-o-hostname.md)
- [7.2 Testando a Resiliência](./testando-resiliencia.md)
