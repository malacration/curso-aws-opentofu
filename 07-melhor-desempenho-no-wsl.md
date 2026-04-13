---
layout: default
title: 7. Melhor desempenho no WSL
permalink: /wsl-desempenho/
prev_title: 2. Ubuntu no Windows (WSL)
prev_url: /ubuntu-no-windows-wsl/
next_title: 3. AWS CLI e Login
next_url: /aws-cli-login/
---

# 7. Melhor desempenho no WSL

Se voce estiver no Windows usando `WSL 2`, o principal ganho de desempenho vem de manter os arquivos do curso dentro do filesystem Linux do Ubuntu, e nao dentro do disco do Windows montado em `/mnt/c`.

## 7.1 Caminho recomendado

Use um caminho como este dentro do Ubuntu:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

Exemplo de pasta para este curso:

```bash
~/cursos/aws-tofu
```

## 7.2 Caminho a evitar

Evite trabalhar em caminhos como:

```bash
/mnt/c/Users/seu-usuario/Desktop/aws-tofu
```

ou

```bash
/mnt/c/Users/seu-usuario/Documents/aws-tofu
```

Esses caminhos costumam ficar mais lentos para:

- `git status`
- `terraform` ou `tofu init`
- instalacao de dependencias
- leitura e escrita intensiva de arquivos

## 7.3 Melhor forma de usar no curso

1. Abra o Ubuntu.
2. Entre em uma pasta dentro do seu `home`.
3. Mantenha o projeto do curso dentro desse caminho Linux.
4. Abra a pasta pelo VS Code usando a extensao `WSL`.

## 7.4 Exemplo pratico

Se voce recebeu os arquivos do curso no Windows, prefira copiar ou clonar novamente dentro do Ubuntu:

```bash
mkdir -p ~/cursos
cd ~/cursos
git clone <url-do-repositorio>
```

Se o material nao estiver em um repositorio Git, voce pode copiar os arquivos para dentro do Ubuntu e seguir trabalhando a partir de la.

## 7.5 VS Code no WSL

A forma mais eficiente de editar no Windows com `WSL 2` e:

- instalar o `VS Code` no Windows;
- instalar a extensao `WSL`;
- abrir a pasta do projeto a partir do terminal do Ubuntu com:

```bash
code .
```

Assim, o editor roda no Windows, mas os arquivos permanecem no Linux, o que normalmente entrega a melhor combinacao de desempenho e compatibilidade.

## 7.6 Ajuste opcional de recursos do WSL

Se a maquina tiver memoria e CPU suficientes, voce tambem pode limitar melhor os recursos do WSL criando o arquivo `%UserProfile%\.wslconfig` no Windows.

Exemplo:

```ini
[wsl2]
memory=8GB
processors=4
```

Depois disso, reinicie o WSL:

```powershell
wsl --shutdown
```

Esse ajuste e opcional. O principal ganho continua sendo manter os arquivos do curso dentro do Ubuntu, e nao em `/mnt/c`.
