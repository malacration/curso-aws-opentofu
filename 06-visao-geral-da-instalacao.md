---
layout: default
title: 6. Visao Geral da Instalacao
permalink: /visao-geral/
prev_title: 1. Inicio
prev_url: /
next_title: 3. AWS CLI e Login
next_url: /aws-cli-login/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 6. Visao Geral da Instalacao

Este guia resume o caminho de preparacao do ambiente para o curso.

Todo o material presume uma distribuicao baseada em Debian, preferencialmente `Ubuntu`, seja em Linux nativo ou dentro do `WSL`.

## 6.1 Fluxo principal

O curso segue esta continuidade:

1. [3. AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})
2. [4. OpenTofu]({{ '/opentofu/' | relative_url }})
3. [5. Diretorio do Projeto e VS Code]({{ '/diretorio-e-vscode/' | relative_url }})

## 6.2 Preparacao inicial

Antes de instalar as ferramentas do curso, atualize o sistema e instale os pacotes basicos:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl unzip wget gpg ca-certificates apt-transport-https software-properties-common
```

Confira a arquitetura da maquina:

```bash
uname -m
```

Valores mais comuns:

- `x86_64`: processadores Intel e AMD 64 bits
- `aarch64`: processadores ARM 64 bits

## 6.3 AWS CLI e login na AWS

As instrucoes de instalacao da `AWS CLI`, login no perfil `treinamento`, uso de `sa-east-1` e configuracao de `AWS_CA_BUNDLE` foram separadas em:

[3. AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})

## 6.4 Instalacao do OpenTofu

As instrucoes detalhadas de instalacao do `OpenTofu` estao em:

[4. OpenTofu]({{ '/opentofu/' | relative_url }})

## 6.5 Instalacao do Visual Studio Code

Para Ubuntu nativo, use o repositorio oficial da Microsoft para facilitar atualizacoes futuras.

### 6.5.1 Instale a chave do repositorio

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f packages.microsoft.gpg
```

### 6.5.2 Adicione o repositorio do VS Code

```bash
printf "Types: deb\nURIs: https://packages.microsoft.com/repos/code\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg\n" \
  | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
```

### 6.5.3 Instale o editor

```bash
sudo apt update
sudo apt install -y code
```

### 6.5.4 Validacao

```bash
code --version
```

## 6.6 Configuracao inicial recomendada

Depois de instalar as ferramentas, a verificacao minima do ambiente pode ser feita com:

```bash
tofu --version
code --version
```

## 6.7 Extensoes recomendadas no VS Code

Para acompanhar o curso com menos friccao, instale pelo menos:

- `HashiCorp Terraform`
- `AWS Toolkit`

## 6.8 Referencias oficiais

- VS Code no Linux: https://code.visualstudio.com/docs/setup/linux
