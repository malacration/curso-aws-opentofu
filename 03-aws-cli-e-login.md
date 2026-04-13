---
layout: default
title: 3. AWS CLI e Login
permalink: /aws-cli-login/
prev_title: 1. Início
prev_url: /
next_title: 4. OpenTofu
next_url: /opentofu/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 3. AWS CLI e Login

Este guia cobre:

- instalação da `AWS CLI`;
- login no ambiente de treinamento;
- uso do perfil treinamento;
- configuração de `AWS_CA_BUNDLE` em ambientes com inspeção SSL.

## 3.1 Instalação da AWS CLI

A instalação abaixo usa o instalador oficial da AWS para Linux.

### 3.1.1 Instalação simples por arquitetura da máquina

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

### 3.1.2 Validação

```bash
aws --version
```

### 3.1.3 Limpeza opcional

```bash
rm -rf aws awscliv2.zip
```

## 3.2 Região do treinamento

Neste curso, use a região:

```bash
sa-east-1
```

Se quiser definir isso logo no início:

```bash
aws configure set region sa-east-1
```

## 3.3 Login no ambiente de treinamento

Neste curso, o ambiente de treinamento usa o perfil treinamento.

No `WSL`, o login deve ser feito com o método remoto porque o navegador do Windows não consegue se comunicar com a CLI da mesma forma que em um Linux nativo. Por isso, no `WSL`, o uso de `aws login --remote` é obrigatório.

### 3.3.1 Comando para Linux nativo

Use este comando se estiver em Linux nativo:

```bash
aws login --profile treinamento
```

Quando a AWS CLI pedir a região, informe:

```bash
sa-east-1
```

### 3.3.2 Comando para Windows com WSL

Use este comando se estiver no Windows com `WSL`:

```bash
aws login --remote --profile treinamento
```

Quando a AWS CLI pedir a região, informe:

```bash
sa-east-1
```

No `WSL`, não use `aws login --profile treinamento` sem `--remote`.

## 3.4 Validação do login

Depois do login, confirme a identidade carregada:

```bash
aws sts get-caller-identity --profile treinamento
```

Se quiser confirmar de onde a AWS CLI está lendo as credenciais:

```bash
aws configure list --profile treinamento
```

O tipo esperado para esse fluxo é `login`.

## 3.5 Usar o perfil treinamento como padrão na sessão atual

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

## 3.6 Inspeção SSL e AWS_CA_BUNDLE

Se a rede da empresa intercepta conexões HTTPS, pode ser necessário confiar na CA corporativa antes de usar `curl`, `apt` ou `aws`.

Depois de clonar o projeto, entre na raiz do repositório antes de executar os scripts:

```bash
cd aws-tofu
```

O script de apoio fica em:

[`scripts/install-proxy-ca.sh`]({{ '/scripts/install-proxy-ca.sh' | relative_url }})

Se você executar sem argumentos, ele usa este destino padrão:

```bash
globo.com:443
```

Exemplo usando o padrão:

```bash
./scripts/install-proxy-ca.sh
```

Exemplo de uso para testar especificamente o login da AWS:

```bash
./scripts/install-proxy-ca.sh --target sa-east-1.signin.aws.amazon.com:443 --sni sa-east-1.signin.aws.amazon.com
```

O script:

- instala os certificados de CA apresentados na conexão;
- verifica se o bundle do sistema existe em `/etc/ssl/certs/ca-certificates.crt`;
- adiciona `export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt` em `~/.bashrc` e `~/.zshrc`, se esses arquivos existirem.

Se quiser aplicar isso imediatamente na sessão atual do terminal:

```bash
export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
```

Se quiser conferir se o bundle realmente existe:

```bash
ls /etc/ssl/certs/
test -f /etc/ssl/certs/ca-certificates.crt && echo "bundle ok" || echo "bundle não existente"
```

Depois de rodar o script, abra um novo terminal ou recarregue seu shell:

```bash
source ~/.bashrc
```

Ou, se estiver usando `zsh`:

```bash
source ~/.zshrc
```

## 3.7 Referências oficiais

- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- AWS CLI login: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sign-in.html
