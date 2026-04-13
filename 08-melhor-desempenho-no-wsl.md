---
layout: default
title: 8. Melhor desempenho no WSL
permalink: /wsl-desempenho/
prev_title: 2. Ubuntu no Windows (WSL)
prev_url: /ubuntu-no-windows-wsl/
next_title: 3. Inspeção SSL e AWS_CA_BUNDLE
next_url: /inspecao-ssl-ca-bundle/
---

# 8. Melhor desempenho no WSL

Se você estiver no Windows usando `WSL 2`, o principal ganho de desempenho vem de manter os arquivos do curso dentro do filesystem Linux do Ubuntu, e não dentro do disco do Windows montado em `/mnt/c`.

## 8.1 Caminho recomendado

Use um caminho como este dentro do Ubuntu:

```bash
mkdir -p ~/cursos
cd ~/cursos
```

Exemplo de pasta para este curso:

```bash
~/cursos/aws-tofu
```

## 8.2 Caminho a evitar

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
- instalação de dependências
- leitura e escrita intensiva de arquivos

## 8.3 Melhor forma de usar no curso

1. Abra o Ubuntu.
2. Entre em uma pasta dentro do seu `home`.
3. Mantenha o projeto do curso dentro desse caminho Linux.
4. Abra a pasta pelo VS Code usando a extensão `WSL`.

## 8.4 Exemplo prático

Se você recebeu os arquivos do curso no Windows, prefira copiar ou clonar novamente dentro do Ubuntu:

```bash
mkdir -p ~/cursos
cd ~/cursos
git clone <url-do-repositorio>
```

Se o material não estiver em um repositório Git, você pode copiar os arquivos para dentro do Ubuntu e seguir trabalhando a partir de lá.

## 8.5 VS Code no WSL

A forma mais eficiente de editar no Windows com `WSL 2` é:

- instalar o `VS Code` no Windows;
- instalar a extensão `WSL`;
- abrir a pasta do projeto a partir do terminal do Ubuntu com:

```bash
code .
```

Assim, o editor roda no Windows, mas os arquivos permanecem no Linux, o que normalmente entrega a melhor combinação de desempenho e compatibilidade.

## 8.6 Ajuste opcional de recursos do WSL

Se a máquina tiver memória e CPU suficientes, você também pode limitar melhor os recursos do WSL criando o arquivo `%UserProfile%\.wslconfig` no Windows.

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

Esse ajuste é opcional. O principal ganho continua sendo manter os arquivos do curso dentro do Ubuntu, e não em `/mnt/c`.
