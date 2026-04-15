---
layout: default
title: 2. Ubuntu no Windows (WSL)
permalink: /ubuntu-no-windows-wsl/
prev_title: 1. Início
prev_url: /
next_title: 3. Inspeção SSL e AWS_CA_BUNDLE
next_url: /inspecao-ssl-ca-bundle/
optional_title: 2.1 Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 2. Ubuntu no Windows (WSL)

Este guia cobre a preparação do `Ubuntu` dentro do `WSL 2` para quem estuda no Windows.

<blockquote><strong>⚡ Visão rápida:</strong> aqui o objetivo é deixar o ambiente Linux funcional no Windows antes de avançar para AWS CLI, OpenTofu e projeto local.</blockquote>

## 2.1 Distribuição recomendada

Use preferencialmente:

- `Ubuntu`
- ou outra distribuição baseada em Debian, se necessário

## 2.2 Instalar o WSL 2

Abra o `PowerShell` como administrador e execute:

```powershell
wsl --install -d Ubuntu
```

Depois:

1. reinicie o computador, se o Windows solicitar;
2. abra o Ubuntu instalado;
3. conclua a criação do seu usuário Linux;
4. confirme se o WSL está funcionando:

```powershell
wsl --status
```

## 2.3 Recomendação para este curso

Depois de instalar o Ubuntu no `WSL 2`:

- instale `AWS CLI` e `OpenTofu` dentro do Ubuntu;
- para login na AWS CLI, use obrigatoriamente `aws login --remote`;
- para editar os arquivos, use o `VS Code` no Windows com a extensão `WSL`.
