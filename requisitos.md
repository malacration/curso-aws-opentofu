---
layout: default
title: Requisitos
permalink: /requisitos/
---

# Requisitos

Para acompanhar este curso, prepare o ambiente abaixo antes de iniciar as aulas.

## Sistema operacional

- Linux, preferencialmente uma distribuicao derivada de Debian
- Recomendacao principal: Ubuntu
- Windows tambem pode ser usado, desde que execute o ambiente Linux via WSL

## Se voce usa Windows

Se estiver no Windows, instale o **WSL 2** e utilize de preferencia o **Ubuntu** como distribuicao Linux.

### Instalacao recomendada

1. Abra o **PowerShell** como administrador.
2. Execute:

```bash
wsl --install -d Ubuntu
```

3. Reinicie o computador, se o Windows solicitar.
4. Abra o Ubuntu instalado e conclua a criacao do seu usuario Linux.
5. Confirme se o WSL esta funcionando com:

```bash
wsl --status
```

Se a distribuicao Ubuntu nao estiver disponivel no seu ambiente, outra distribuicao baseada em Debian tambem atende ao curso.

Para melhorar o desempenho no Windows com `WSL 2`, siga tambem o guia em [WSL com Melhor Desempenho]({{ '/wsl-desempenho/' | relative_url }}).

## Se voce usa Linux

Se ja estiver em Linux, **ignore completamente a etapa de instalacao do WSL**.

Neste caso, a recomendacao continua sendo usar:

- Ubuntu
- Debian
- outra distribuicao derivada de Debian, quando necessario

## Ferramentas necessarias

- AWS CLI versao 2.34.x ou superior
- Terminal com acesso ao ambiente Linux
- Permissao para instalar pacotes no sistema

## Recomendacao pratica

Para reduzir diferencas de ambiente durante o curso, use preferencialmente:

- Ubuntu no WSL 2, se estiver no Windows
- Ubuntu nativo, se estiver no Linux

## Proximo passo

Depois de preparar o sistema operacional, siga o guia de instalacao em [Guia de Instalacao no Ubuntu]({{ '/instalacao-ubuntu/' | relative_url }}).

As instrucoes da `AWS CLI` e do login no ambiente de treinamento estao em [AWS CLI no Ubuntu]({{ '/aws-cli-ubuntu/' | relative_url }}).

As instrucoes de instalacao do `OpenTofu` estao em [Instalar o OpenTofu no Ubuntu]({{ '/opentofu-ubuntu/' | relative_url }}).
