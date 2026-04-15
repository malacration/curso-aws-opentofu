---
layout: default
title: 3. Inspeção SSL e AWS_CA_BUNDLE
permalink: /inspecao-ssl-ca-bundle/
prev_title: 1. Início
prev_url: /
next_title: 4. Instalando a AWS CLI e Fazendo Login
next_url: /aws-cli-login/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 3. Inspeção SSL e AWS_CA_BUNDLE

Se a rede da empresa intercepta conexões HTTPS, pode ser necessário confiar na CA corporativa antes de usar `curl`, `apt` ou `aws`.

<blockquote><strong>⚡ Visão rápida:</strong> este passo existe para evitar falhas de certificado e garantir que downloads, login e instalação funcionem dentro de redes corporativas.</blockquote>

## 3.1 Entrar na raiz do projeto

Depois de clonar o projeto, entre na raiz do repositório antes de executar os scripts:

```bash
cd aws-tofu
```

## 3.2 Script de apoio

O script de apoio fica em:

[`scripts/install-proxy-ca.sh`]({{ '/scripts/install-proxy-ca.sh' | relative_url }})

## 3.3 Baixar o script com `curl -k`

Se você ainda não conseguiu baixar o projeto por causa da inspeção SSL, pode buscar o script uma única vez ignorando a verificação de certificado:

```bash
curl -k -L https://raw.githubusercontent.com/malacration/curso-aws-opentofu/main/scripts/install-proxy-ca.sh -o install-proxy-ca.sh
chmod +x install-proxy-ca.sh
```

Use `-k` apenas como bootstrap inicial para obter o script.

## 3.4 Executar o script

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

## 3.5 O que o script faz

O script:

- instala os certificados de CA apresentados na conexão;
- verifica se o bundle do sistema existe em `/etc/ssl/certs/ca-certificates.crt`;
- adiciona `export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt` em `~/.bashrc` e `~/.zshrc`, se esses arquivos existirem.

## 3.6 Aplicar o bundle na sessão atual

Se quiser aplicar isso imediatamente na sessão atual do terminal:

```bash
export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
```

## 3.7 Validar se o bundle existe

Se quiser conferir se o bundle realmente existe:

```bash
ls /etc/ssl/certs/
test -f /etc/ssl/certs/ca-certificates.crt && echo "bundle ok" || echo "bundle não existente"
```

## 3.8 Recarregar o shell

Depois de rodar o script, abra um novo terminal ou recarregue seu shell:

```bash
source ~/.bashrc
```

Ou, se estiver usando `zsh`:

```bash
source ~/.zshrc
```
