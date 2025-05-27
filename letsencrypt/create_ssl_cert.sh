#!/usr/bin/env bash
set -euo pipefail

BASE="/path/to/ssl-certs"

echo "SSL-Zertifikat-Anfrage über Cloudflare DNS"

read -rp "Gib den Domainnamen ein (z.B. example.com): " DOMAIN
read -rp "Wildcard-Zertifikat erstellen? (y/n): " WILDCARD

if [[ "${WILDCARD,,}" == "y" ]]; then
  CERT_DOMAINS="-d *.${DOMAIN} -d ${DOMAIN}"
  echo "Wildcard-Zertifikat wird erstellt."
else
  CERT_DOMAINS="-d ${DOMAIN}"
  echo "Standard-Zertifikat wird erstellt."
fi

TARGET_DIR="${BASE}/${DOMAIN}"
mkdir -p "${TARGET_DIR}"

if [[ "${WILDCARD,,}" == "y" ]]; then
  certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /path/to/secrets/.cloudflare.ini \
    --dns-cloudflare-propagation-seconds 60 \
    --agree-tos --non-interactive \
    ${CERT_DOMAINS} \
    --email your@email.tld \
    --rsa-key-size 4096 \
    --preferred-challenges dns-01
else
  certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /path/to/secrets/.cloudflare.ini \
    --dns-cloudflare-propagation-seconds 60 \
    --agree-tos --non-interactive \
    ${CERT_DOMAINS} \
    --email your@email.tld \
    --rsa-key-size 4096
fi

for FILE in privkey.pem fullchain.pem cert.pem chain.pem; do
  SRC="/etc/letsencrypt/live/${DOMAIN}/${FILE}"
  if [[ -e "${SRC}" ]]; then
    ln -sf "${SRC}" "${TARGET_DIR}/${FILE}"
    echo "Symlink erstellt: ${TARGET_DIR}/${FILE}"
  else
    echo "Datei nicht gefunden: ${SRC}"
  fi
done

echo "Fertig. Zertifikate sind unter ${TARGET_DIR} verlinkt."
