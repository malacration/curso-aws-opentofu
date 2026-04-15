output "primeiro_plano" {
  value = "meu primeiro bloco"
}

output "segundo_plano" {
  value = "meu segundo bloco"
}

terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "null_resource" "exemplo" {
  triggers = {
    nome = "gadelha.com"
  }
}
