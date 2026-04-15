---
layout: default
title: 1. Início
permalink: /
next_title: 3. Inspeção SSL e AWS_CA_BUNDLE
next_url: /inspecao-ssl-ca-bundle/
optional_title: 2. Ubuntu no Windows (WSL)
optional_url: /ubuntu-no-windows-wsl/
---

# 1. OpenTofu na AWS: do Zero à Infraestrutura Real

<div style="padding: 1.25rem 1.4rem; border: 1px solid var(--border); border-radius: 1rem; background: linear-gradient(135deg, rgba(34, 197, 94, 0.12), rgba(125, 211, 252, 0.08)); margin-bottom: 1.25rem;">
  <p style="margin: 0 0 0.5rem 0; font-size: 0.82rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--text-soft);"><strong>Infraestrutura como código na prática</strong></p>
  <h2 style="margin: 0 0 0.65rem 0; font-size: clamp(1.5rem, 2.6vw, 2.4rem); line-height: 1.15;">Construa uma base real na AWS com VPC, subnets, EC2, user_data e load balancer.</h2>
  <p style="margin: 0; color: var(--text-soft);">Este curso foi organizado para sair da preparação do ambiente e chegar em uma arquitetura funcional, versionada e reproduzível com OpenTofu.</p>
</div>

<blockquote><strong>⚡ Visão rápida:</strong> comece por esta página para entender o fluxo do curso, os pré-requisitos e os caminhos alternativos para Windows e Linux.</blockquote>

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
- [2.1 Melhor desempenho no WSL]({{ '/wsl-desempenho/' | relative_url }})
- [Script de apoio para CA corporativa]({{ '/scripts/install-proxy-ca.sh' | relative_url }})
