---
layout: default
title: 6. Visão Geral da Instalação
permalink: /visao-geral/
prev_title: 1. Início
prev_url: /
next_title: 3. AWS CLI e Login
next_url: /aws-cli-login/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 6. Visão Geral da Instalação

Este guia resume o caminho de preparação do ambiente para o curso.

Todo o material presume uma distribuição baseada em Debian, preferencialmente `Ubuntu`, seja em Linux nativo ou dentro do `WSL`.

## 6.1 Fluxo principal

O curso segue esta continuidade:

1. [3. AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})
2. [4. OpenTofu]({{ '/opentofu/' | relative_url }})
3. [5. Diretório do Projeto e VS Code]({{ '/diretorio-e-vscode/' | relative_url }})

## 6.2 Preparação inicial

Antes de instalar as ferramentas do curso, atualize o sistema e instale os pacotes básicos:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl unzip wget gpg ca-certificates apt-transport-https software-properties-common
```

Confira a arquitetura da máquina:

```bash
uname -m
```

Valores mais comuns:

- `x86_64`: processadores Intel e AMD 64 bits
- `aarch64`: processadores ARM 64 bits

## 6.3 AWS CLI e login na AWS

As instruções de instalação da `AWS CLI`, login no perfil `treinamento`, uso de `sa-east-1` e configuração de `AWS_CA_BUNDLE` foram separadas em:

[3. AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})

## 6.4 Instalação do OpenTofu

As instruções detalhadas de instalação do `OpenTofu` estão em:

[4. OpenTofu]({{ '/opentofu/' | relative_url }})

## 6.5 Instalação do Visual Studio Code

Para Ubuntu nativo, use o repositório oficial da Microsoft para facilitar atualizações futuras.

### 6.5.1 Instale a chave do repositório

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f packages.microsoft.gpg
```

### 6.5.2 Adicione o repositório do VS Code

```bash
printf "Types: deb\nURIs: https://packages.microsoft.com/repos/code\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg\n" \
  | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
```

### 6.5.3 Instale o editor

```bash
sudo apt update
sudo apt install -y code
```

### 6.5.4 Validação

```bash
code --version
```

## 6.6 Configuração inicial recomendada

Depois de instalar as ferramentas, a verificação mínima do ambiente pode ser feita com:

```bash
tofu --version
code --version
```

## 6.7 Extensões recomendadas no VS Code

Para acompanhar o curso com menos fricção, instale pelo menos:

- `HashiCorp Terraform`
- `AWS Toolkit`

## 6.8 Referências oficiais

- VS Code no Linux: https://code.visualstudio.com/docs/setup/linux
