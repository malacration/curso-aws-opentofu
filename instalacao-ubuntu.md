---
layout: default
title: Guia de Instalacao no Ubuntu
permalink: /instalacao-ubuntu/
---

# Guia de Instalacao no Ubuntu

Este guia presume que o aluno ja esta em um ambiente Ubuntu, seja nativo ou dentro do WSL.

Se estiver usando Ubuntu dentro do WSL:

- instale `AWS CLI` e `OpenTofu` dentro do Ubuntu;
- para o `VS Code`, a opcao mais recomendada e instalar o editor no Windows e usar a extensao `WSL`;
- para login na AWS CLI, use obrigatoriamente `aws login --remote`;
- se estiver em Ubuntu nativo, siga normalmente a instalacao do VS Code neste guia.

## Preparacao inicial

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

## 1. AWS CLI e login na AWS

As instrucoes de instalacao da `AWS CLI`, login no perfil `treinamento`, uso de `sa-east-1` e configuracao de `AWS_CA_BUNDLE` foram separadas em:

[AWS CLI no Ubuntu]({{ '/aws-cli-ubuntu/' | relative_url }})

## 2. Instalacao do OpenTofu

As instrucoes detalhadas de instalacao do `OpenTofu` estao em:

[Instalar o OpenTofu no Ubuntu]({{ '/opentofu-ubuntu/' | relative_url }})

## 3. Instalacao do Visual Studio Code

Para Ubuntu nativo, use o repositorio oficial da Microsoft para facilitar atualizacoes futuras.

### Instale a chave do repositorio

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f packages.microsoft.gpg
```

### Adicione o repositorio do VS Code

```bash
printf "Types: deb\nURIs: https://packages.microsoft.com/repos/code\nSuites: stable\nComponents: main\nArchitectures: amd64,arm64,armhf\nSigned-By: /usr/share/keyrings/microsoft.gpg\n" \
  | sudo tee /etc/apt/sources.list.d/vscode.sources > /dev/null
```

### Instale o editor

```bash
sudo apt update
sudo apt install -y code
```

### Validacao

```bash
code --version
```

Depois da instalacao, siga o passo de criacao da pasta do curso e abertura no editor em [Criar Diretorio e Abrir no VS Code]({{ '/diretorio-e-vscode/' | relative_url }}).

## Configuracao inicial recomendada

Depois de instalar as ferramentas, a verificacao minima do ambiente pode ser feita com:

```bash
tofu --version
code --version
```

## Extensoes recomendadas no VS Code

Para acompanhar o curso com menos friccao, instale pelo menos:

- `HashiCorp Terraform`
- `AWS Toolkit`

## Referencias oficiais

- VS Code no Linux: https://code.visualstudio.com/docs/setup/linux
