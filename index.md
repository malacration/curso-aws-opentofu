---
layout: default
title: 1. Início
permalink: /
next_title: 3. Inspeção SSL e AWS_CA_BUNDLE
next_url: /inspecao-ssl-ca-bundle/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 1. Curso AWS + OpenTofu

Este site reúne os guias de preparação do ambiente do curso.

Todo o material foi pensado para distribuições baseadas em Debian, preferencialmente `Ubuntu`.

## 1.1 Sistema operacional

- Linux, preferencialmente uma distribuição derivada de Debian
- Recomendação principal: Ubuntu
- Windows também pode ser usado, desde que execute o ambiente Linux via WSL

## 1.2 🪟 No Windows

Se estiver no Windows, use preferencialmente `Ubuntu` dentro do `WSL 2`.

O guia para esse caso está em [Ubuntu no Windows (WSL)]({{ '/ubuntu-no-windows-wsl/' | relative_url }}).

## 1.3 🐧 No Linux

Se já estiver em Linux, ignore a etapa de instalação do `WSL`.

Neste caso, a recomendação continua sendo usar:

- Ubuntu
- Debian
- outra distribuição derivada de Debian, quando necessário

## 1.4 Ferramentas necessárias

- AWS CLI versão 2.34.x ou superior
- Terminal com acesso ao ambiente Linux
- Permissão para instalar pacotes no sistema

## 1.5 Estrutura do guia

O fluxo principal do curso está separado por ferramenta:

1. [3. Inspeção SSL e AWS_CA_BUNDLE]({{ '/inspecao-ssl-ca-bundle/' | relative_url }})
2. [4. Instalando a AWS CLI e Fazendo Login]({{ '/aws-cli-login/' | relative_url }})
3. [5. Instalando o OpenTofu]({{ '/opentofu/' | relative_url }})
4. [6. Diretório do Projeto e VS Code]({{ '/diretorio-e-vscode/' | relative_url }})

## 1.6 Guias complementares

- [7. Conceitos do OpenTofu]({{ '/conceitos-opentofu/' | relative_url }})
- [8. Melhor desempenho no WSL]({{ '/wsl-desempenho/' | relative_url }})
- [Script de apoio para CA corporativa]({{ '/scripts/install-proxy-ca.sh' | relative_url }})
