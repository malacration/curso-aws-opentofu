---
layout: default
title: 5. Instalando o OpenTofu
permalink: /opentofu/
prev_title: 4. Instalando a AWS CLI e Fazendo Login
prev_url: /aws-cli-login/
next_title: 6. Diretório do Projeto e VS Code
next_url: /diretorio-e-vscode/
---

# 5. Instalando o OpenTofu

Este guia usa o repositório oficial do OpenTofu para distribuições baseadas em `.deb`, como Ubuntu e Debian.

<blockquote><strong>⚡ Visão rápida:</strong> depois deste passo, a máquina fica pronta para executar `tofu init`, `tofu plan`, `tofu apply` e as fases práticas do curso.</blockquote>

## 5.1 Instalar os pacotes necessários

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg
```

## 5.2 Adicionar as chaves e o `keyring`

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg > /dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```

## 5.3 Adicionar o repositório oficial

```bash
echo \
"deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
  | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```

## 5.4 Instalar o OpenTofu

```bash
sudo apt update
sudo apt install -y tofu
```

## 5.5 Validar a instalação

```bash
tofu --version
```

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://opentofu.org/docs/intro/install/deb/">Abrir documentação de instalação do OpenTofu para Debian e Ubuntu</a>
</blockquote>
