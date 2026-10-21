#!/bin/bash
#
# enable-web-auth.sh - Turn on password authentication for the PiNode-XMR web
# console, creating a credential if none exists.
#
#   sudo ./enable-web-auth.sh                 # keep existing password, or generate one
#   sudo ./enable-web-auth.sh --set-password  # prompt for a password interactively
#
# The console exposes node lifecycle control - start/stop services, shutdown,
# reboot, blockchain pruning - and the mining payout address. Without
# authentication anyone who can reach the node on port 80 can drive all of it.
#
# No default password ships with the project. When no credential exists and the
# script is not run interactively, a random one is generated and written to
# /root/pinode-web-credentials (root-only). That keeps a fresh install
# authenticated from first boot without a guessable shared secret.
#
# Safe to re-run. Requires root.

set -u
USER_NAME="${WEB_USER_NAME:-pinodexmr}"
HTPASSWD=/etc/apache2/.htpasswd
VHOST=/etc/apache2/sites-enabled/000-default.conf
SRC=/home/pinodexmr/variables/000-default-passwordAuthEnabled.conf
FLAG=/home/pinodexmr/variables/htmlPasswordRequired.sh
CREDS=/root/pinode-web-credentials

[ "$(id -u)" -eq 0 ] || { echo "Run with sudo." >&2; exit 1; }
command -v htpasswd >/dev/null 2>&1 || { echo "htpasswd not found - install apache2-utils." >&2; exit 1; }
[ -f "$SRC" ] || { echo "Missing $SRC - is this a PiNode-XMR install?" >&2; exit 1; }

GENERATED=""
if [ "${1:-}" = "--set-password" ]; then
  echo "Setting the web console password for user '$USER_NAME'."
  htpasswd -c "$HTPASSWD" "$USER_NAME" || exit 1
elif [ ! -s "$HTPASSWD" ]; then
  # No credential yet. Generate one rather than shipping a known default.
  GENERATED="$(head -c 18 /dev/urandom | base64 | tr -d '/+=' | cut -c1-20)"
  htpasswd -bc "$HTPASSWD" "$USER_NAME" "$GENERATED" >/dev/null 2>&1 || exit 1
  umask 077
  printf 'PiNode-XMR web console\nusername: %s\npassword: %s\n' "$USER_NAME" "$GENERATED" > "$CREDS"
  chmod 600 "$CREDS"
fi

# The credential file is read by Apache (as www-data) but must not be readable
# by anyone else on the device.
chown root:www-data "$HTPASSWD" 2>/dev/null || chown root "$HTPASSWD"
chmod 640 "$HTPASSWD"

cp "$SRC" "$VHOST"
chown root:root "$VHOST"
chmod 644 "$VHOST"

printf '#!/bin/sh\nHTMLPASSWORDREQUIRED=TRUE\n' > "$FLAG"
chmod 664 "$FLAG" 2>/dev/null || true

if apache2ctl configtest >/dev/null 2>&1; then
  systemctl restart apache2 2>/dev/null || service apache2 restart 2>/dev/null || apache2ctl -k restart 2>/dev/null
else
  echo "Apache rejected the configuration; leaving the previous vhost in place." >&2
  apache2ctl configtest
  exit 1
fi

echo "Web console authentication is enabled."
if [ -n "$GENERATED" ]; then
  echo
  echo "  A password was generated for you:"
  echo "    username: $USER_NAME"
  echo "    password: $GENERATED"
  echo
  echo "  Saved to $CREDS (root only)."
  echo "  Change it with:  sudo /home/pinodexmr/enable-web-auth.sh --set-password"
  echo
fi
