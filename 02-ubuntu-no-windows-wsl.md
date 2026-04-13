---
layout: default
title: 2. Ubuntu no Windows (WSL)
permalink: /ubuntu-no-windows-wsl/
prev_title: 1. Inicio
prev_url: /
next_title: 3. AWS CLI e Login
next_url: /aws-cli-login/
optional_title: 7. Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 2. Ubuntu no Windows (WSL)

Este guia cobre a preparacao do `Ubuntu` dentro do `WSL 2` para quem estuda no Windows.

## 2.1 Distribuicao recomendada

Use preferencialmente:

- `Ubuntu`
- ou outra distribuicao baseada em Debian, se necessario

## 2.2 Instalar o WSL 2

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

## 2.3 Recomendacao para este curso

Depois de instalar o Ubuntu no `WSL 2`:

- instale `AWS CLI` e `OpenTofu` dentro do Ubuntu;
- para login na AWS CLI, use obrigatoriamente `aws login --remote`;
- para editar os arquivos, use o `VS Code` no Windows com a extensao `WSL`.
