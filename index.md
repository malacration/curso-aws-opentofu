---
layout: default
title: 1. Inicio
permalink: /
next_title: 3. AWS CLI e Login
next_url: /aws-cli-login/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 1. Curso AWS + OpenTofu

Este site reune os guias de preparacao do ambiente do curso.

Todo o material foi pensado para distribuicoes baseadas em Debian, preferencialmente `Ubuntu`.

## 1.1 Sistema operacional

- Linux, preferencialmente uma distribuicao derivada de Debian
- Recomendacao principal: Ubuntu
- Windows tambem pode ser usado, desde que execute o ambiente Linux via WSL

## 1.2 Se voce usa Windows

Se estiver no Windows, use preferencialmente `Ubuntu` dentro do `WSL 2`.

O guia para esse caso esta em [Ubuntu no Windows (WSL)]({{ '/ubuntu-no-windows-wsl/' | relative_url }}).

## 1.3 Se voce usa Linux

Se ja estiver em Linux, ignore a etapa de instalacao do `WSL`.

Neste caso, a recomendacao continua sendo usar:

- Ubuntu
- Debian
- outra distribuicao derivada de Debian, quando necessario

## 1.4 Ferramentas necessarias

- AWS CLI versao 2.34.x ou superior
- Terminal com acesso ao ambiente Linux
- Permissao para instalar pacotes no sistema

## 1.5 Estrutura do guia

O fluxo principal do curso esta separado por ferramenta:

1. [3. AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})
2. [4. OpenTofu]({{ '/opentofu/' | relative_url }})
3. [5. Diretorio do Projeto e VS Code]({{ '/diretorio-e-vscode/' | relative_url }})

## 1.6 Guias complementares

- [6. Visao Geral da Instalacao]({{ '/visao-geral/' | relative_url }})
- [7. Melhor desempenho no WSL]({{ '/wsl-desempenho/' | relative_url }})
- [Script de apoio para CA corporativa]({{ '/scripts/install-proxy-ca.sh' | relative_url }})
