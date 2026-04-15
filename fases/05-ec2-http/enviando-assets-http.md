---
layout: default
title: 5.2 Enviando Assets HTTP
permalink: /fases/05-ec2-http/enviando-assets-http/
prev_title: 5.1 Criando a EC2
prev_url: /fases/05-ec2-http/criando-a-ec2/
next_title: 5.3 Acessando a Página Web
next_url: /fases/05-ec2-http/acessando-a-pagina-web/
---

# 5.2 Enviando Assets HTTP

Nesta etapa, vamos preparar os arquivos HTML e ligá-los ao `user_data` da instância.

<blockquote><strong>⚡ Visão rápida:</strong> em vez de usar SSH para copiar arquivos, vamos fazer o OpenTofu ler assets locais e incorporá-los ao script de inicialização da EC2.</blockquote>

<blockquote>
  <strong>🧠 Mergulho profundo</strong><br>
  Documentação oficial:
  <br>
  <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance">Abrir documentação do recurso <code>aws_instance</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/functions/templatefile">Abrir documentação da função <code>templatefile()</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/functions/file">Abrir documentação da função <code>file()</code></a>
  <br>
  <a href="https://developer.hashicorp.com/terraform/language/functions/filesha256">Abrir documentação da função <code>filesha256()</code></a>
</blockquote>

## 5.2.1 Criar a estrutura de assets

Crie um diretório no projeto chamado `assets/http`.

Dentro dele, crie um arquivo `index.html`. O exemplo abaixo usa Bootstrap via CDN para um visual básico e já traz a mensagem de parabéns:

```html
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Servidor Apache na Nuvem</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous"
    >
    <style>
      body {
        background: linear-gradient(135deg, #0f172a 0%, #1e3a5f 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .card {
        border: none;
        border-radius: 1.25rem;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
      }
      .badge-iac {
        background-color: #f97316;
        font-size: 0.75rem;
        letter-spacing: 0.05em;
      }
      .icon-check {
        font-size: 4rem;
      }
    </style>
  </head>
  <body>
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
          <div class="card p-5 text-center">

            <div class="icon-check mb-3">🎉</div>

            <span class="badge badge-iac rounded-pill mb-3 mx-auto px-3 py-2">
              Infraestrutura como Código
            </span>

            <h1 class="fw-bold mb-2">Parabéns!</h1>

            <p class="text-muted mb-4">
              Você subiu com sucesso um servidor <strong>Apache</strong> na
              <strong>AWS</strong> utilizando <strong>OpenTofu</strong>.
            </p>

            <hr class="my-4">

            <ul class="list-unstyled text-start text-muted small mb-0">
              <li class="mb-2">✅ EC2 provisionada com OpenTofu</li>
              <li class="mb-2">✅ Apache instalado via <code>user_data</code></li>
              <li class="mb-2">✅ Página publicada automaticamente no boot</li>
              <li>✅ Infraestrutura versionada como código</li>
            </ul>

          </div>
        </div>
      </div>
    </div>
  </body>
</html>
```

## 5.2.2 Criar o template de `user_data`

Ainda dentro de `assets/http`, crie um arquivo chamado `user-data.sh.tftpl`.

Nesse arquivo, coloque um script como este:

```bash
#!/bin/bash
set -e

apt-get update -y
apt-get install -y apache2

cat >/var/www/html/index.html <<'HTML'
${index_html}
HTML

chown -R www-data:www-data /var/www/html
systemctl enable apache2
systemctl restart apache2
```

Esse template será renderizado pelo OpenTofu no momento em que a instância for criada.

Ou seja: o conteúdo do `index.html` local será injetado no script e executado no boot da EC2.

## 5.2.3 Ligar os assets à instância

No recurso `aws_instance.http_server` em `ec2.tf`, adicione:

```hcl
user_data = templatefile("${path.module}/assets/http/user-data.sh.tftpl", {
  index_html = file("${path.module}/assets/http/index.html")
})
```

Aqui:

- `file(...)` lê o conteúdo do `index.html` local;
- `templatefile(...)` renderiza o script `user-data.sh.tftpl`;
- `user_data` envia esse script para a EC2 executar no boot.

Existem outras maneiras de preparar uma instância:

- provisioners por SSH;
- AWS SSM;
- imagens já preparadas;
- ferramentas de configuração como Ansible.

Para efeitos práticos deste curso, a forma escolhida foi `user_data`, porque ela é mais simples e reduz dependência de acesso manual à máquina.

## 5.2.4 Recriar a instância quando os assets mudarem

Existe um detalhe importante sobre o `user_data`: ele só é executado **uma única vez**, no primeiro boot da instância.

Isso significa que, se você alterar o `index.html` e rodar `tofu apply`, o OpenTofu detecta a mudança — mas por padrão **não vai recriar a instância**. A EC2 continua rodando com o conteúdo antigo.

### Por que o `index.html` afeta o `user_data`?

O fluxo é o seguinte:

1. `file("...index.html")` lê o conteúdo do arquivo local;
2. esse conteúdo é passado para `templatefile(...)`, que o injeta no script `user-data.sh.tftpl`;
3. o resultado renderizado é o valor de `user_data` que chega à EC2.

Portanto, qualquer mudança no `index.html` altera o `user_data` resultante.

### Garantindo a recriação com `user_data_replace_on_change`

Adicione o atributo ao recurso:

```hcl
user_data_replace_on_change = true
```

Com isso, o OpenTofu calcula o hash do `user_data` renderizado e o armazena no state. Quando o `index.html` muda, o hash muda, e o plano indica a destruição e recriação da instância.

### Tornando a mudança visível no plano com `filesha256`

Para deixar ainda mais explícito no plano qual arquivo foi modificado, adicione o hash do `index.html` como uma tag da instância:

```hcl
tags = {
  Name          = "${var.vpc_name}-${aws_subnet.subnets[0].id}-http-server"
  IndexHtmlHash = filesha256("${path.module}/assets/http/index.html")
}
```

`filesha256(...)` calcula o SHA-256 do arquivo em tempo de plan. Quando o `index.html` muda:

- a tag `IndexHtmlHash` muda no plano — tornando visível **qual arquivo** foi alterado;
- o `user_data` renderizado também muda;
- `user_data_replace_on_change = true` detecta a mudança no `user_data` e marca a instância para recriação.

As duas abordagens se complementam: `user_data_replace_on_change` garante a recriação, e a tag com `filesha256` documenta no plano e no painel da AWS qual versão do HTML está em uso.

<blockquote>
  <strong>⚠️ Observação prática</strong><br>
  A recriação derruba a instância antes de criar a nova. Se a EC2 estiver servindo tráfego real, isso gera uma breve indisponibilidade. Para ambientes de produção, outros mecanismos como AMIs pré-configuradas ou Auto Scaling com rolling update são mais adequados.
</blockquote>

## 5.2.5 Aplicar

Agora execute:

```bash
tofu apply
```

Ao final, a EC2 deve continuar existindo, e o conteúdo do `index.html` local já deve estar incorporado ao `user_data` que será executado na instância.
