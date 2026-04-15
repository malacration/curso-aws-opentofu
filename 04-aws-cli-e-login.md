---
layout: default
title: 4. Instalando a AWS CLI e Fazendo Login
permalink: /aws-cli-login/
prev_title: 3. Inspeção SSL e AWS_CA_BUNDLE
prev_url: /inspecao-ssl-ca-bundle/
next_title: 5. Instalando o OpenTofu
next_url: /opentofu/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 4. Instalando a AWS CLI e Fazendo Login

Este guia cobre:

- instalação da `AWS CLI`;
- login no ambiente de treinamento;
- uso do perfil treinamento.

<blockquote><strong>⚡ Visão rápida:</strong> este é o ponto em que a autenticação com a AWS passa a existir de forma reutilizável para os próximos passos do curso.</blockquote>

## 4.1 Instalação da AWS CLI

A instalação abaixo usa o instalador oficial da AWS para Linux.

### 4.1.1 Instalação simples por arquitetura da máquina

Copie e execute os comandos abaixo, um por vez:

```bash
ARCH="$(uname -m)"
```

```bash
if [ "$ARCH" = "x86_64" ]; then
  AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
  AWSCLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
else
  echo "Arquitetura não suportada neste guia: $ARCH"
fi
```

```bash
echo "$AWSCLI_URL"
```

```bash
curl "$AWSCLI_URL" -o "awscliv2.zip"
```

```bash
unzip awscliv2.zip
```

```bash
sudo ./aws/install
```

### 4.1.2 Validação

```bash
aws --version
```

### 4.1.3 Limpeza opcional

```bash
rm -rf aws awscliv2.zip
```

## 4.2 Região do treinamento

Neste curso, use a região:

```bash
sa-east-1
```

Se quiser definir isso logo no início:

```bash
aws configure set region sa-east-1
```

## 4.3 Login no ambiente de treinamento

Neste curso, o ambiente de treinamento usa o perfil treinamento.

No `WSL`, o login deve ser feito com o método remoto porque o navegador do Windows não consegue se comunicar com a CLI da mesma forma que em um Linux nativo. Por isso, no `WSL`, o uso de `aws login --remote` é obrigatório.

### 4.3.1 Comando para Linux nativo

Use este comando se estiver em Linux nativo:

```bash
aws login --profile treinamento
```

Quando a AWS CLI pedir a região, informe:

```bash
sa-east-1
```

### 4.3.2 Comando para Windows com WSL

Use este comando se estiver no Windows com `WSL`:

```bash
aws login --remote --profile treinamento
```

Quando a AWS CLI pedir a região, informe:

```bash
sa-east-1
```

No `WSL`, não use `aws login --profile treinamento` sem `--remote`.

## 4.4 Validação do login

Depois do login, confirme a identidade carregada:

```bash
aws sts get-caller-identity --profile treinamento
```

Se quiser confirmar de onde a AWS CLI está lendo as credenciais:

```bash
aws configure list --profile treinamento
```

O tipo esperado para esse fluxo é `login`.

## 4.5 Usar o perfil treinamento como padrão na sessão atual

Se quiser evitar `--profile treinamento` em todos os comandos:

```bash
export AWS_PROFILE=treinamento
```

Depois disso:

```bash
aws sts get-caller-identity
```

Para remover essa definição apenas da sessão atual:

```bash
unset AWS_PROFILE
```

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html">Abrir documentação da instalação da AWS CLI</a>
  <br>
  <a href="https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sign-in.html">Abrir documentação do login da AWS CLI</a>
</blockquote>
