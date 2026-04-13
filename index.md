---
layout: default
title: Inicio
permalink: /
next_title: AWS CLI e Login
next_url: /aws-cli-login/
optional_title: Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# Curso AWS + OpenTofu

Este site reune os guias de preparacao do ambiente do curso.

Todo o material foi pensado para distribuicoes baseadas em Debian, preferencialmente `Ubuntu`.

## Sistema operacional

- Linux, preferencialmente uma distribuicao derivada de Debian
- Recomendacao principal: Ubuntu
- Windows tambem pode ser usado, desde que execute o ambiente Linux via WSL

## Se voce usa Windows

Se estiver no Windows, use preferencialmente `Ubuntu` dentro do `WSL 2`.

O guia para esse caso esta em [Ubuntu no Windows (WSL)]({{ '/ubuntu-no-windows-wsl/' | relative_url }}).

## Se voce usa Linux

Se ja estiver em Linux, ignore a etapa de instalacao do `WSL`.

Neste caso, a recomendacao continua sendo usar:

- Ubuntu
- Debian
- outra distribuicao derivada de Debian, quando necessario

## Ferramentas necessarias

- AWS CLI versao 2.34.x ou superior
- Terminal com acesso ao ambiente Linux
- Permissao para instalar pacotes no sistema

## Estrutura do guia

O fluxo principal do curso esta separado por ferramenta:

1. [AWS CLI e Login]({{ '/aws-cli-login/' | relative_url }})
2. [OpenTofu]({{ '/opentofu/' | relative_url }})
3. [Diretorio do Projeto e VS Code]({{ '/diretorio-e-vscode/' | relative_url }})

## Guias complementares

- [Visao Geral da Instalacao]({{ '/visao-geral/' | relative_url }})
- [Melhor desempenho no WSL]({{ '/wsl-desempenho/' | relative_url }})
- [Script de apoio para CA corporativa]({{ '/scripts/install-proxy-ca.sh' | relative_url }})
