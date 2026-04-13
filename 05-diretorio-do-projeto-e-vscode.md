---
layout: default
title: 5. Diretorio do Projeto e VS Code
permalink: /diretorio-e-vscode/
prev_title: 4. OpenTofu
prev_url: /opentofu/
next_title: 6. Visao Geral da Instalacao
next_url: /visao-geral/
optional_title: 7. Melhor desempenho no WSL
optional_url: /wsl-desempenho/
---

# 5. Diretorio do Projeto e VS Code

Este passo organiza o ambiente do curso e garante que voce abra a pasta correta no `VS Code`.

## 5.1 Se voce acabou de clonar o projeto

No terminal, execute:

```bash
cd ~/cursos/aws-tofu
```

Se quiser confirmar onde voce esta:

```bash
pwd
```

O caminho esperado sera parecido com:

```bash
/home/seu-usuario/cursos/aws-tofu
```

## 5.2 Se voce ainda nao criou a pasta base

Antes de clonar ou copiar os arquivos do curso, voce pode preparar a estrutura assim:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

## 5.3 Abrir esse diretorio no VS Code

Ainda dentro da pasta do curso, execute:

```bash
code .
```

Isso abre o `VS Code` exatamente no diretorio atual.

## 5.4 Se estiver usando WSL

No `WSL`, siga estas orientacoes extras:

- crie a pasta dentro do Linux, por exemplo em `~/cursos/aws-tofu`;
- nao trabalhe em caminhos como `/mnt/c/...`;
- instale o `VS Code` no Windows;
- use a extensao `WSL` no `VS Code`;
- abra a pasta a partir do terminal do Ubuntu com `code .`.

Fluxo recomendado no `WSL`:

```bash
cd ~/cursos/aws-tofu
code .
```

## 5.5 Se o comando `code` nao funcionar

Verifique se o `VS Code` foi instalado corretamente.

No Ubuntu nativo:

- confirme a instalacao com `code --version`.

No `WSL`:

- confirme se o `VS Code` esta instalado no Windows;
- confirme se a extensao `WSL` esta instalada;
- feche e abra novamente o terminal do Ubuntu e tente `code .` outra vez.
