---
layout: default
title: 5. Diretório do Projeto e VS Code
permalink: /diretorio-e-vscode/
prev_title: 4. OpenTofu
prev_url: /opentofu/
next_title: 6. Visão Geral da Instalação
next_url: /visao-geral/
optional_title: 7. Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 5. Diretório do Projeto e VS Code

Este passo organiza o ambiente do curso e garante que você abra a pasta correta no `VS Code`.

## 5.1 Se você acabou de clonar o projeto

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

## 5.2 Se você ainda não criou a pasta base

Antes de clonar ou copiar os arquivos do curso, você pode preparar a estrutura assim:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

## 5.3 Abrir esse diretório no VS Code

Ainda dentro da pasta do curso, execute:

```bash
code .
```

Isso abre o `VS Code` exatamente no diretório atual.

## 5.4 Se estiver usando WSL

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

## 5.5 Se o comando `code` não funcionar

Verifique se o `VS Code` foi instalado corretamente.

No Ubuntu nativo:

- confirme a instalação com `code --version`.

No `WSL`:

- confirme se o `VS Code` está instalado no Windows;
- confirme se a extensão `WSL` está instalada;
- feche e abra novamente o terminal do Ubuntu e tente `code .` outra vez.
