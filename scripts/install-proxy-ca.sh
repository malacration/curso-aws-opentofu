#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Uso:
  install-proxy-ca.sh [--target host:porta] [--sni host] [--proxy host:porta] [--install-name nome] [--yes]

Exemplos:
  install-proxy-ca.sh
  install-proxy-ca.sh --target globo.com:443 --sni globo.com
  install-proxy-ca.sh --target globo.com:443 --proxy proxy.empresa.local:8080 --sni globo.com

O script:
  1. captura a cadeia de certificados apresentada na conexão;
  2. identifica os certificados de CA na cadeia;
  3. instala esses certificados no trust store do Ubuntu;
  4. executa update-ca-certificates;
  5. valida o bundle do sistema para uso com AWS CLI;
  6. adiciona AWS_CA_BUNDLE em ~/.bashrc e ~/.zshrc, se esses arquivos existirem.

Importante:
  - para proxy com inspeção TLS, o ideal é confiar na CA do proxy;
  - se a raiz da CA não vier na cadeia, será preciso exportá-la manualmente.
EOF
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Comando obrigatório não encontrado: $cmd" >&2
    exit 1
  fi
}

sanitize_name() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9._-]/-/g'
}

append_export_if_missing() {
  local rc_file="$1"
  local export_line="$2"

  if [[ ! -f "$rc_file" ]]; then
    echo "Arquivo não encontrado, nada a persistir: $rc_file"
    return 0
  fi

  if grep -Fxq "$export_line" "$rc_file"; then
    echo "Configuração já existente em $rc_file"
    return 0
  fi

  printf '\n%s\n' "$export_line" >> "$rc_file"
  echo "Configuração adicionada em $rc_file"
}

TARGET="globo.com:443"
SNI="globo.com"
PROXY=""
INSTALL_NAME="proxy-ca"
AUTO_YES="false"
BUNDLE_DIR="/etc/ssl/certs"
BUNDLE_PATH="$BUNDLE_DIR/ca-certificates.crt"
BUNDLE_EXPORT="export AWS_CA_BUNDLE=$BUNDLE_PATH"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --sni)
      SNI="${2:-}"
      shift 2
      ;;
    --proxy)
      PROXY="${2:-}"
      shift 2
      ;;
    --install-name)
      INSTALL_NAME="${2:-}"
      shift 2
      ;;
    --yes)
      AUTO_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Argumento inválido: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$SNI" ]]; then
  SNI="${TARGET%%:*}"
fi

require_cmd openssl
require_cmd awk
require_cmd sed
require_cmd grep
require_cmd mktemp
require_cmd sudo
require_cmd update-ca-certificates

WORKDIR="$(mktemp -d)"
CERTDIR="$WORKDIR/certs"
INSTALL_STAGING="$WORKDIR/install"
mkdir -p "$CERTDIR" "$INSTALL_STAGING"

cleanup() {
  rm -rf "$WORKDIR"
}
trap cleanup EXIT

OPENSSL_ARGS=(-showcerts -connect "$TARGET" -servername "$SNI")
if [[ -n "$PROXY" ]]; then
  OPENSSL_ARGS=(-showcerts -proxy "$PROXY" -connect "$TARGET" -servername "$SNI")
fi

echo "Capturando cadeia SSL..."
openssl s_client "${OPENSSL_ARGS[@]}" </dev/null >"$WORKDIR/chain.txt" 2>"$WORKDIR/openssl.log" || {
  cat "$WORKDIR/openssl.log" >&2
  exit 1
}

awk -v outdir="$CERTDIR" '
  /-----BEGIN CERTIFICATE-----/ {
    in_cert = 1
    cert_count++
    file = sprintf("%s/cert-%02d.pem", outdir, cert_count)
  }
  in_cert {
    print > file
  }
  /-----END CERTIFICATE-----/ {
    in_cert = 0
    close(file)
  }
' "$WORKDIR/chain.txt"

shopt -s nullglob
CERT_FILES=("$CERTDIR"/*.pem)
shopt -u nullglob

if [[ ${#CERT_FILES[@]} -eq 0 ]]; then
  echo "Nenhum certificado foi extraído da conexão." >&2
  exit 1
fi

echo
echo "Certificados capturados:"

CA_COUNT=0
for cert in "${CERT_FILES[@]}"; do
  subject="$(openssl x509 -in "$cert" -noout -subject -nameopt RFC2253 | sed 's/^subject=//')"
  issuer="$(openssl x509 -in "$cert" -noout -issuer -nameopt RFC2253 | sed 's/^issuer=//')"
  fingerprint="$(openssl x509 -in "$cert" -noout -fingerprint -sha256 | sed 's/^sha256 Fingerprint=//')"

  if openssl x509 -in "$cert" -noout -text | grep -q "CA:TRUE"; then
    is_ca="sim"
    CA_COUNT=$((CA_COUNT + 1))
    base_name="$(sanitize_name "${INSTALL_NAME}-$(basename "$cert" .pem)")"
    install_path="$INSTALL_STAGING/${base_name}.crt"
    cp "$cert" "$install_path"
  else
    is_ca="não"
  fi

  echo "- arquivo: $(basename "$cert")"
  echo "  subject: $subject"
  echo "  issuer: $issuer"
  echo "  sha256: $fingerprint"
  echo "  CA: $is_ca"
done

echo
if [[ "$CA_COUNT" -eq 0 ]]; then
  echo "Nenhum certificado de CA foi encontrado na cadeia apresentada." >&2
  echo "Isso costuma indicar que a CA raiz/intermediária do proxy não foi enviada na conexão." >&2
  echo "Nesse caso, exporte a CA do proxy manualmente e instale no sistema." >&2
  exit 1
fi

echo "Foram encontrados $CA_COUNT certificado(s) de CA para instalar."
echo "Revise os fingerprints acima antes de continuar."

if [[ "$AUTO_YES" != "true" ]]; then
  read -r -p "Instalar esses certificados no trust store do Ubuntu? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES)
      ;;
    *)
      echo "Instalação cancelada."
      exit 0
      ;;
  esac
fi

sudo mkdir -p /usr/local/share/ca-certificates/custom-proxy
sudo cp "$INSTALL_STAGING"/*.crt /usr/local/share/ca-certificates/custom-proxy/
sudo update-ca-certificates

echo
echo "Certificados instalados em /usr/local/share/ca-certificates/custom-proxy"

if [[ ! -d "$BUNDLE_DIR" ]]; then
  echo "bundle não existente: diretório não encontrado em $BUNDLE_DIR" >&2
  exit 1
fi

if [[ ! -f "$BUNDLE_PATH" ]]; then
  echo "bundle não existente: $BUNDLE_PATH" >&2
  exit 1
fi

echo "Bundle do sistema encontrado: $BUNDLE_PATH"
echo "Arquivos disponíveis em $BUNDLE_DIR:"
ls "$BUNDLE_DIR"

export AWS_CA_BUNDLE="$BUNDLE_PATH"
echo
echo "AWS_CA_BUNDLE validado dentro do script:"
echo "export AWS_CA_BUNDLE=$BUNDLE_PATH"
echo "Para aplicar na sessão atual do terminal, rode esse export manualmente ou recarregue ~/.bashrc ou ~/.zshrc."

echo
echo "Persistindo AWS_CA_BUNDLE nos arquivos de shell existentes..."
append_export_if_missing "$HOME/.bashrc" "$BUNDLE_EXPORT"
append_export_if_missing "$HOME/.zshrc" "$BUNDLE_EXPORT"

echo "Se o problema persistir, a CA raiz do proxy provavelmente não veio na cadeia e precisará ser exportada manualmente."
