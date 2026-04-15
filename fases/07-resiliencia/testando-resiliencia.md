---
layout: default
title: 7.2 Testando a Resiliência
permalink: /fases/07-resiliencia/testando-resiliencia/
prev_title: 7.1 Exibindo o Hostname na Página
prev_url: /fases/07-resiliencia/exibindo-o-hostname/
next_title: 8. Conceitos do OpenTofu
next_url: /conceitos-opentofu/
---

# 7.2 Testando a Resiliência

Nesta etapa, vamos simular uma falha real: destruir uma instância manualmente pelo painel da AWS e verificar que o serviço continua funcionando.

<blockquote><strong>⚡ Visão rápida:</strong> com três instâncias e um Load Balancer com health check, a perda de uma máquina não derruba o serviço. Depois de confirmar isso, vamos usar o OpenTofu para recuperar a infraestrutura ao estado desejado — com apenas um comando.</blockquote>

## 7.2.1 Identificar as instâncias

Antes de destruir, anote os IDs das três instâncias em execução:

```bash
tofu output
```

Ou acesse o painel EC2 da AWS em **Instâncias** e localize as três com o nome `andrew-42-http-server-0`, `1` e `2`.

## 7.2.2 Destruir uma instância pelo painel da AWS

No painel EC2 da AWS:

1. Selecione **uma** das instâncias (qualquer uma das três);
2. Clique em **Estado da instância → Encerrar instância**;
3. Confirme o encerramento.

<blockquote>
  <strong>⚠️ Atenção</strong><br>
  Escolha <strong>Encerrar</strong> (terminate), não <strong>Parar</strong> (stop). O encerramento remove a instância permanentemente — é isso que queremos simular: uma falha irrecuperável.
</blockquote>

## 7.2.3 Verificar que o serviço continua funcionando

Imediatamente após encerrar a instância, acesse o DNS do ALB:

```bash
curl http://$(tofu output -raw alb_dns)
```

A página deve continuar respondendo normalmente, servida pelas duas instâncias restantes.

O que acontece nos bastidores:

- o **health check** do Target Group detecta que a instância encerrada não responde mais;
- após `unhealthy_threshold = 2` falhas consecutivas (em até 30 segundos com `interval = 15`), o ALB marca a instância como `unhealthy`;
- o tráfego passa a ser distribuído apenas entre as instâncias saudáveis.

## 7.2.4 Verificar o estado do Target Group

No painel da AWS, acesse **EC2 → Target Groups → andrew-42-tg → Targets**.

Você vai ver algo como:

| Instância        | Estado     |
|------------------|------------|
| i-0abc123...     | healthy    |
| i-0def456...     | healthy    |
| i-0ghi789...     | unused / draining |

A instância encerrada aparece como `unused` ou `draining` até ser removida automaticamente do Target Group.

## 7.2.5 Verificar o state do OpenTofu

O OpenTofu ainda acredita que as três instâncias existem — ele não sabe que uma foi destruída externamente. Para verificar a divergência entre o state e a realidade:

```bash
tofu plan
```

O plano vai mostrar que uma instância precisa ser **criada** — porque o recurso que estava registrado no state não existe mais na AWS.

Esse é o momento em que o state diverge da infraestrutura real. O OpenTofu detecta a diferença e sabe exatamente o que precisa ser feito para restaurar o estado desejado.

## 7.2.6 Recuperar a infraestrutura

Execute:

```bash
tofu apply
```

O OpenTofu cria a instância faltante, registra ela no Target Group e o serviço volta a ter três instâncias.

Após o apply, aguarde o boot e o health check (cerca de 1 a 2 minutos) e execute novamente:

```bash
for i in $(seq 1 6); do
  curl -s http://$(tofu output -raw alb_dns) | grep "Servido por"
done
```

Os três IDs de instância devem voltar a aparecer nas respostas — incluindo o novo ID gerado para a instância recriada.

## 7.2.7 Resultado esperado

Esta etapa demonstra três ideias centrais:

- 🔁 **Alta disponibilidade**: a perda de uma instância não derruba o serviço — o ALB redireciona o tráfego automaticamente para as instâncias saudáveis;
- 🔍 **Detecção de divergência**: o OpenTofu compara o state com a infraestrutura real e identifica exatamente o que mudou;
- 🛠️ **Recuperação declarativa**: para restaurar o estado desejado, basta um `tofu apply` — sem scripts manuais, sem reconstrução manual da máquina.
