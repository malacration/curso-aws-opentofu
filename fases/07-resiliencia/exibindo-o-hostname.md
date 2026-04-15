---
layout: default
title: 7.1 Exibindo o Hostname na Página
permalink: /fases/07-resiliencia/exibindo-o-hostname/
prev_title: 7. Resiliência e Alta Disponibilidade
prev_url: /fases/07-resiliencia/
next_title: 7.2 Testando a Resiliência
next_url: /fases/07-resiliencia/testando-resiliencia/
---

# 7.1 Exibindo o Hostname na Página

Nesta etapa, vamos fazer cada instância escrever seu próprio hostname na página HTML durante o boot.

<blockquote><strong>⚡ Visão rápida:</strong> o HTML é um arquivo estático — não tem como saber em qual máquina está rodando. A solução é usar o <code>user_data</code> para, no momento do boot, ler o hostname da instância e injetá-lo diretamente no arquivo.</blockquote>

## 7.1.1 O hostname da instância

Cada instância EC2 tem um hostname único atribuído pela AWS no momento em que é criada. Ele fica disponível localmente em `/etc/hostname` — um arquivo simples que qualquer script pode ler:

```bash
cat /etc/hostname
```

O valor retornado tem um formato como `ip-10-0-1-45.sa-east-1.compute.internal`, derivado do IP privado da instância. É único por instância e suficiente para identificar qual máquina está respondendo.

## 7.1.2 Adicionar o marcador no `index.html`

No `index.html`, adicione um parágrafo ao final do card com o texto `__INSTANCE_ID__` como marcador:

```html
<hr class="mt-4 mb-3">

<p class="instance-tag mb-0">
  Servido por: <code>__INSTANCE_ID__</code>
</p>
```

Adicione também o estilo para o texto no `<style>`:

```css
.instance-tag {
  font-size: 1rem;
  letter-spacing: 0.03em;
  color: #94a3b8;
}
```

Esse marcador é um texto literal que será substituído pelo `user_data` no momento do boot. O OpenTofu não precisa saber disso — para ele, é só conteúdo de arquivo.

## 7.1.3 Modificar o `user-data.sh.tftpl`

Após escrever o HTML, o script precisa:

1. Ler o hostname da instância em `/etc/hostname`;
2. Substituir o marcador `__INSTANCE_ID__` pelo valor real usando `sed`.

```bash
#!/bin/bash
set -e

apt-get update -y
apt-get install -y apache2

cat >/var/www/html/index.html <<'HTML'
${index_html}
HTML

# Captura o hostname da instância
INSTANCE_ID=$(cat /etc/hostname)

# Substitui o marcador pelo hostname real da instância
sed -i "s/__INSTANCE_ID__/$${INSTANCE_ID}/g" /var/www/html/index.html

chown -R www-data:www-data /var/www/html
systemctl enable apache2
systemctl restart apache2
```

<blockquote>
  <strong>⚠️ Por que <code>$${INSTANCE_ID}</code> com dois cifrões?</strong><br>
  O OpenTofu processa o arquivo <code>.tftpl</code> com <code>templatefile()</code> antes de enviar o script para a EC2. Qualquer <code>${...}</code> é interpretado como variável do template — não como variável bash. O <code>$$</code> é a forma de escapar: o OpenTofu renderiza <code>$$</code> como um único <code>$</code> literal, e o bash recebe <code>${INSTANCE_ID}</code> corretamente em tempo de execução.
</blockquote>

O fluxo é:

1. o `cat` escreve o HTML com o marcador literal `__INSTANCE_ID__`;
2. `cat /etc/hostname` lê o hostname único da instância;
3. o `sed -i` substitui o marcador no arquivo já escrito em disco.

## 7.1.4 Aplicar

Como o `index.html` foi modificado, o hash `IndexHtmlHash` da tag vai mudar. Combinado com `user_data_replace_on_change = true`, o OpenTofu vai recriar as três instâncias com o novo script.

Execute:

```bash
tofu apply
```

<blockquote>
  <strong>⏳ Aguarde o boot das instâncias</strong><br>
  Cada instância precisa passar pelo <code>user_data</code> completo antes de servir a página. Aguarde 1 a 2 minutos após o apply.
</blockquote>

## 7.1.5 Testar

Acesse o DNS do ALB várias vezes:

```bash
for i in $(seq 1 6); do
  curl -s http://$(tofu output -raw alb_dns) | grep "Servido por"
done
```

A cada requisição, o ALB pode rotear para uma instância diferente. O ID exibido na página deve alternar entre os três IDs das instâncias.

No navegador, recarregue com `Ctrl+Shift+R` (sem cache) algumas vezes — o ID no rodapé da página vai mudar conforme o ALB distribui o tráfego.
