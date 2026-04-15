---
layout: default
title: 5.3 Acessando a Página Web
permalink: /fases/05-ec2-http/acessando-a-pagina-web/
prev_title: 5.2 Enviando Assets HTTP
prev_url: /fases/05-ec2-http/enviando-assets-http/
next_title: 6. Load Balancer
next_url: /fases/06-load-balancer/
---

# 5.3 Acessando a Página Web

Nesta etapa, vamos verificar que a página HTML está sendo servida pela EC2.

<blockquote><strong>⚡ Visão rápida:</strong> o Apache é instalado automaticamente pelo <code>user_data</code> no boot da instância. Aqui o objetivo é confirmar que tudo funcionou — e entender como acessar e validar o servidor.</blockquote>

## 5.3.1 O que acontece no boot

Quando a instância sobe, o `user_data` é executado uma única vez. O script:

- atualiza os pacotes do sistema;
- instala o Apache;
- escreve o `index.html` em `/var/www/html/index.html`;
- habilita e inicia o serviço.

A máquina já nasce configurada — não é necessário acessar por SSH para instalar nada manualmente.

## 5.3.2 Obter o IP público

Ao final do `apply`, o output `ec2_public_ip` exibe o IP da instância:

```bash
tofu output ec2_public_ip
```

Ou para capturar apenas o valor:

```bash
tofu output -raw ec2_public_ip
```

## 5.3.3 Acessar a página no navegador

Abra no navegador:

```
http://SEU_IP_PUBLICO
```

A página HTML preparada no projeto deve aparecer servida pelo Apache.

<blockquote>
  <strong>⏳ Se a página não carregar imediatamente</strong><br>
  O <code>user_data</code> roda em background após o boot. Pode levar 1 a 2 minutos até o Apache estar disponível. Aguarde e recarregue a página.
</blockquote>

## 5.3.4 Verificar pelo terminal

Para testar sem abrir o navegador, use `curl`:

```bash
curl http://$(tofu output -raw ec2_public_ip)
```

Se o Apache estiver respondendo, o conteúdo do `index.html` aparece no terminal.

## 5.3.5 Verificar dentro da instância via SSH

Se a página não responder, acesse a instância para inspecionar o serviço:

```bash
ssh -i <sua-chave.pem> ubuntu@$(tofu output -raw ec2_public_ip)
```

Dentro da instância:

```bash
# Status do Apache
sudo systemctl status apache2

# Logs de erro
sudo tail -f /var/log/apache2/error.log

# Confirmar que o arquivo HTML está no lugar certo
cat /var/www/html/index.html
```

## 5.3.6 Resultado esperado

Ao final da fase 5, o projeto terá:

- 🖥️ uma instância EC2 com IP público;
- 🔓 um security group com porta `80` liberada;
- 📁 assets HTTP locais incorporados ao `user_data`;
- 🌐 Apache instalado e servindo a página HTML no boot;
- 🔁 recriação automática da instância ao alterar o `index.html`.

![EC2 em execução com página HTTP acessível]({{ '/fases/05-ec2-http/assets/5-1-ec2-em-execucao.png' | relative_url }})
