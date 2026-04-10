---
layout: default
title: AWS CLI no Ubuntu
permalink: /aws-cli-ubuntu/
---

# AWS CLI no Ubuntu

Este guia cobre:

- instalacao da `AWS CLI`;
- login no ambiente de treinamento;
- uso do perfil `treinamento`;
- configuracao de `AWS_CA_BUNDLE` em ambientes com inspecao SSL.

## Instalacao da AWS CLI

A instalacao abaixo usa o instalador oficial da AWS para Linux.

### Instalacao simples por arquitetura da maquina

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
  echo "Arquitetura nao suportada neste guia: $ARCH"
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

### Validacao

```bash
aws --version
```

### Limpeza opcional

```bash
rm -rf aws awscliv2.zip
```

## Regiao do treinamento

Neste curso, use a regiao:

```bash
sa-east-1
```

Se quiser definir isso logo no inicio:

```bash
aws configure set region sa-east-1
```

## Login no ambiente de treinamento

Neste curso, o ambiente de treinamento usa o perfil:

```bash
treinamento
```

### Ubuntu nativo

Se estiver em Ubuntu nativo, execute:

```bash
aws login --profile treinamento
```

Quando a AWS CLI pedir a regiao, informe:

```bash
sa-east-1
```

### WSL

Se estiver no `WSL`, use obrigatoriamente:

```bash
aws login --remote --profile treinamento
```

Quando a AWS CLI pedir a regiao, informe:

```bash
sa-east-1
```

No `WSL`, nao use `aws login --profile treinamento` sem `--remote`.

## Validacao do login

Depois do login, confirme a identidade carregada:

```bash
aws sts get-caller-identity --profile treinamento
```

Se quiser confirmar de onde a AWS CLI esta lendo as credenciais:

```bash
aws configure list --profile treinamento
```

O tipo esperado para esse fluxo e `login`.

## Usar o perfil `treinamento` como padrao na sessao atual

Se quiser evitar `--profile treinamento` em todos os comandos:

```bash
export AWS_PROFILE=treinamento
```

Depois disso:

```bash
aws sts get-caller-identity
```

Para remover essa definicao apenas da sessao atual:

```bash
unset AWS_PROFILE
```

## Inspecao SSL e AWS_CA_BUNDLE

Se a rede da empresa intercepta conexoes HTTPS, pode ser necessario confiar na CA corporativa antes de usar `curl`, `apt` ou `aws`.

Depois de clonar o projeto, entre na raiz do repositorio antes de executar os scripts:

```bash
cd aws-tofu
```

O script de apoio fica em:

[`scripts/install-proxy-ca.sh`]({{ '/scripts/install-proxy-ca.sh' | relative_url }})

Se voce executar sem argumentos, ele usa este destino padrao:

```bash
globo.com:443
```

Exemplo usando o padrao:

```bash
./scripts/install-proxy-ca.sh
```

Exemplo de uso para testar especificamente o login da AWS:

```bash
./scripts/install-proxy-ca.sh --target sa-east-1.signin.aws.amazon.com:443 --sni sa-east-1.signin.aws.amazon.com
```

O script:

- instala os certificados de CA apresentados na conexao;
- verifica se o bundle do sistema existe em `/etc/ssl/certs/ca-certificates.crt`;
- adiciona `export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt` em `~/.bashrc` e `~/.zshrc`, se esses arquivos existirem.

Se quiser aplicar isso imediatamente na sessao atual do terminal:

```bash
export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
```

Se quiser conferir se o bundle realmente existe:

```bash
ls /etc/ssl/certs/
test -f /etc/ssl/certs/ca-certificates.crt && echo "bundle ok" || echo "bundle nao existente"
```

Depois de rodar o script, abra um novo terminal ou recarregue seu shell:

```bash
source ~/.bashrc
```

ou, se estiver usando `zsh`:

```bash
source ~/.zshrc
```

## Referencias oficiais

- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
- AWS CLI login: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sign-in.html
