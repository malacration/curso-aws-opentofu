---
layout: default
title: OpenTofu
permalink: /opentofu/
prev_title: AWS CLI e Login
prev_url: /aws-cli-login/
next_title: Diretorio do Projeto e VS Code
next_url: /diretorio-e-vscode/
---

# OpenTofu

Este guia usa o repositorio oficial do OpenTofu para distribuicoes baseadas em `.deb`, como Ubuntu e Debian.

## 1. Instalar os pacotes necessarios

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg
```

## 2. Adicionar as chaves e o `keyring`

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg > /dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
```

## 3. Adicionar o repositorio oficial

```bash
echo \
"deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" \
  | sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list
```

## 4. Instalar o OpenTofu

```bash
sudo apt update
sudo apt install -y tofu
```

## 5. Validar a instalacao

```bash
tofu --version
```

## Referencia oficial

- OpenTofu Debian/Ubuntu: https://opentofu.org/docs/intro/install/deb/
