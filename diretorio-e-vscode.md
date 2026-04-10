---
layout: default
title: Criar Diretorio e Abrir no VS Code
permalink: /diretorio-e-vscode/
---

# Criar Diretorio e Abrir no VS Code

Este passo organiza o ambiente do curso e garante que voce abra a pasta correta no `VS Code`.

## Se voce acabou de clonar o projeto

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

## Se voce ainda nao criou a pasta base

Antes de clonar ou copiar os arquivos do curso, voce pode preparar a estrutura assim:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

## Abrir esse diretorio no VS Code

Ainda dentro da pasta do curso, execute:

```bash
code .
```

Isso abre o `VS Code` exatamente no diretorio atual.

## Se estiver usando WSL

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

## Se o comando `code` nao funcionar

Verifique se o `VS Code` foi instalado corretamente.

No Ubuntu nativo:

- confirme a instalacao com `code --version`.

No `WSL`:

- confirme se o `VS Code` esta instalado no Windows;
- confirme se a extensao `WSL` esta instalada;
- feche e abra novamente o terminal do Ubuntu e tente `code .` outra vez.
