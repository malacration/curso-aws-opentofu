# OpenTofu na AWS: do Zero à Infraestrutura Real

Material do curso com foco em OpenTofu, AWS CLI e construção progressiva de infraestrutura real na AWS em distribuições baseadas em Debian, preferencialmente Ubuntu.

<blockquote><strong>⚡ Visão rápida:</strong> este repositório reúne a trilha principal de preparação do ambiente e as fases práticas do curso.</blockquote>

## Acesse pelo GitHub Pages

Se você abriu este repositório no GitHub e quer ir direto para a versão navegável do conteúdo, use:

**https://malacration.github.io/curso-aws-opentofu/**

## Conteúdo principal no repositório

- [1. Início](./index.md)
- [2. Ubuntu no Windows (WSL)](./02-ubuntu-no-windows-wsl.md)
- [3. Inspeção SSL e AWS_CA_BUNDLE](./03-inspecao-ssl-e-ca-bundle.md)
- [4. Instalando a AWS CLI e Fazendo Login](./04-aws-cli-e-login.md)
- [5. Instalando o OpenTofu](./05-opentofu.md)
- [6. Diretório do Projeto e VS Code](./06-diretorio-do-projeto-e-vscode.md)
- [7. Conceitos do OpenTofu](./07-conceitos-do-opentofu.md)
- [2.1 Melhor desempenho no WSL](./08-melhor-desempenho-no-wsl.md)

## Fases do curso

- [Fases](./fases/README.md)
- [1. Introdução e Estrutura do Curso](./fases/01-opentofu-e-conceitos/README.md)

## Script de apoio

- [scripts/install-proxy-ca.sh](./scripts/install-proxy-ca.sh)

## Rodar localmente

Para subir o GitHub Pages localmente sem instalar Ruby na máquina, use Docker:

```bash
DOCKER_UID=$(id -u) DOCKER_GID=$(id -g) docker compose up --build
```

Depois, abra:

```text
http://127.0.0.1:4000/
```

O `docker compose` agora monta o diretório local no container, então alterações nos arquivos do projeto devem aparecer automaticamente no Jekyll local.

Os valores `DOCKER_UID` e `DOCKER_GID` fazem o container rodar com o mesmo usuário do host, evitando erros de permissão ao escrever arquivos como `Gemfile.lock`.

Se o navegador não atualizar sozinho, recarregue a página manualmente. O servidor de live reload usa a porta `35729`.

Para parar o ambiente:

```bash
docker compose down
```

Você só precisa usar `--build` novamente quando mudar dependências ou a imagem:

```bash
docker compose up --build
```

Para alterações normais em `.md`, layouts e configurações do site, basta:

```bash
DOCKER_UID=$(id -u) DOCKER_GID=$(id -g) docker compose up
```

## Se o GitHub Pages não abrir

Confira no GitHub:

1. `Settings`
2. `Pages`
3. branch `main`
4. pasta `/ (root)`
