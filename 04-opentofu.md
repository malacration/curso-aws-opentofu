---
layout: default
title: 4. OpenTofu
permalink: /opentofu/
prev_title: 3. AWS CLI e Login
prev_url: /aws-cli-login/
next_title: 5. Diretório do Projeto e VS Code
next_url: /diretorio-e-vscode/
---

# 4. OpenTofu

Este guia usa o repositório oficial do OpenTofu para distribuições baseadas em `.deb`, como Ubuntu e Debian.

## 4.1 Instalar os pacotes necessários

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg
```

## 4.2 Adicionar as chaves e o `keyring`

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg > /dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```

## 4.3 Adicionar o repositório oficial

```bash
echo \
"deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
  | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```

## 4.4 Instalar o OpenTofu

```bash
sudo apt update
sudo apt install -y tofu
```

## 4.5 Validar a instalação

```bash
tofu --version
```

## 4.6 Referência oficial

- OpenTofu Debian/Ubuntu: https://opentofu.org/docs/intro/install/deb/
