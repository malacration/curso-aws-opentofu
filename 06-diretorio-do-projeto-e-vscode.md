---
layout: default
title: 6. Diretório do Projeto e VS Code
permalink: /diretorio-e-vscode/
prev_title: 5. OpenTofu
prev_url: /opentofu/
next_title: 7. Conceitos do OpenTofu
next_url: /conceitos-opentofu/
optional_title: 2.1 Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 6. Diretório do Projeto e VS Code

Este passo organiza o ambiente do curso e garante que você abra a pasta correta no `VS Code`.

<blockquote><strong>⚡ Visão rápida:</strong> aqui a meta é trabalhar no diretório certo, no lugar certo do sistema, com o editor apontando exatamente para o projeto do curso.</blockquote>

## 6.1 Se você acabou de clonar o projeto

No terminal, execute:

```bash
cd ~/cursos/aws-tofu
```

Se quiser confirmar onde você está:

```bash
pwd
```

O caminho esperado será parecido com:

```bash
/home/seu-usuário/cursos/aws-tofu
```

## 6.2 Se você ainda não criou a pasta base

Antes de clonar ou copiar os arquivos do curso, você pode preparar a estrutura assim:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

## 6.3 Abrir esse diretório no VS Code

Se você ainda não instalou o `VS Code`, use o guia oficial:

- https://code.visualstudio.com/docs/setup/setup-overview

Ainda dentro da pasta do curso, execute:

```bash
code .
```

Isso abre o `VS Code` exatamente no diretório atual.

## 6.4 Se estiver usando WSL

No `WSL`, siga estas orientações extras:

- crie a pasta dentro do Linux, por exemplo em `~/cursos/aws-tofu`;
- não trabalhe em caminhos como `/mnt/c/...`;
- instale o `VS Code` no Windows;
- use a extensão `WSL` no `VS Code`;
- abra a pasta a partir do terminal do Ubuntu com `code .`.

Fluxo recomendado no `WSL`:

```bash
cd ~/cursos/aws-tofu
code .
```

## 6.5 Se o comando `code` não funcionar

Verifique se o `VS Code` foi instalado corretamente.

No Ubuntu nativo:

- confirme a instalação com `code --version`.

No `WSL`:

- confirme se o `VS Code` está instalado no Windows;
- confirme se a extensão `WSL` está instalada;
- feche e abra novamente o terminal do Ubuntu e tente `code .` outra vez.
