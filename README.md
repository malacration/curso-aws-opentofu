# Curso AWS + OpenTofu

Material do curso com foco em OpenTofu, AWS CLI e preparação de ambiente em distribuições baseadas em Debian, preferencialmente Ubuntu.

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
- [8. Melhor desempenho no WSL](./08-melhor-desempenho-no-wsl.md)

## Fases do curso

- [Fases](./fases/README.md)
- [01. OpenTofu e Conceitos](./fases/01-opentofu-e-conceitos/README.md)

## Script de apoio

- [scripts/install-proxy-ca.sh](./scripts/install-proxy-ca.sh)

## Rodar localmente

Para subir o GitHub Pages localmente sem instalar Ruby na máquina, use Docker:

```bash
docker compose up --build
```

Depois, abra:

```text
http://127.0.0.1:4000/
```

Para parar o ambiente:

```bash
docker compose down
```

Esse ambiente é isolado. O conteúdo do site é copiado para dentro da imagem no build, sem montar volumes locais.

Se você alterar arquivos do projeto, gere uma nova imagem:

```bash
docker compose up --build
```

## Se o GitHub Pages não abrir

Confira no GitHub:

1. `Settings`
2. `Pages`
3. branch `main`
4. pasta `/ (root)`
