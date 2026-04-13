---
layout: default
title: Windows e WSL
permalink: /windows-wsl/
prev_title: Requisitos
prev_url: /requisitos/
next_title: AWS CLI e Login
next_url: /aws-cli-login/
optional_title: Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# Windows e WSL

Se voce estiver no Windows, este e o passo opcional antes de seguir para a AWS CLI.

Se ja estiver em Linux, ou se o `WSL 2` ja estiver pronto, voce pode pular esta pagina e ir direto para [AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }}).

## Distribuicao recomendada

Use preferencialmente:

- `Ubuntu`
- ou outra distribuicao baseada em Debian, se necessario

## Instalar o WSL 2

Abra o `PowerShell` como administrador e execute:

```powershell
wsl --install -d Ubuntu
```

Depois:

1. reinicie o computador, se o Windows solicitar;
2. abra o Ubuntu instalado;
3. conclua a criacao do seu usuario Linux;
4. confirme se o WSL esta funcionando:

```powershell
wsl --status
```

## Recomendacao para este curso

Depois de instalar o Ubuntu no `WSL 2`:

- instale `AWS CLI` e `OpenTofu` dentro do Ubuntu;
- para login na AWS CLI, use obrigatoriamente `aws login --remote`;
- para editar os arquivos, use o `VS Code` no Windows com a extensao `WSL`.

## Antes de continuar

Se quiser melhorar a experiencia no Windows, leia tambem [Melhor desempenho no WSL]({{ '/wsl-desempenho/' | relative_url }}).

Quando o `WSL` estiver pronto, siga para [AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }}).
