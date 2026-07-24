#!/bin/bash
# Generate ONE global client certificate for IRC SASL EXTERNAL (CertFP), used
# by tiny for every network (see tiny/config.yml). Idempotent: an existing cert
# is kept. The private key never leaves this machine and must not be committed
# (*.pem is gitignored).
set -e

PEM="$HOME/.config/tiny/irc.pem"
CN="${1:-gmelodie}"

mkdir -p "$(dirname "$PEM")"

if [ -f "$PEM" ]; then
    echo "IRC SASL cert already exists at $PEM — keeping it."
else
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    # RSA-4096, unencrypted PKCS#8 key (tiny requires PKCS8), self-signed, 10 yrs.
    openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
        -keyout "$tmpdir/key.pem" -out "$tmpdir/cert.pem" \
        -subj "/CN=$CN"
    cat "$tmpdir/cert.pem" "$tmpdir/key.pem" > "$PEM"
    chmod 600 "$PEM"
    echo "Wrote $PEM"
fi

echo
echo "Certificate SHA-512 fingerprint (Libera/OFTC CertFP):"
openssl x509 -in "$PEM" -noout -fingerprint -sha512 | sed 's/.*Fingerprint=//'
echo
echo "Enroll it once per network. Connect with tiny (the first SASL attempt"
echo "fails and you stay unauthenticated), then in that server's tab run:"
echo "    /msg NickServ IDENTIFY <your-password>"
echo "    /msg NickServ CERT ADD"
echo "After that tiny authenticates automatically with no stored password."
