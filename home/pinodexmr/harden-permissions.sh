#!/bin/bash
#
# harden-permissions.sh - Apply least-privilege ownership/permissions to a
# PiNode-XMR install, replacing the historic `chmod 777 -R` approach.
#
# Why: the installer made /home/pinodexmr/* world-writable so that www-data
# (the web console) could update the handful of files it needs. That also made
# every node start-up script world-writable, meaning any local account or a
# compromised web tier could rewrite e.g. execScripts/moneroPrivate.sh and get
# code execution as pinodexmr - which holds passwordless sudo.
#
# The web console only needs write access to three directories:
#   /home/pinodexmr/variables      (node setting fragments)
#   /home/pinodexmr/execScripts    (custom node start command)
#   /var/www/html                  (status .txt files it refreshes)
#
# This grants exactly that via group ownership, and removes world-write
# everywhere else. Node scripts are launched as `/bin/bash <script>` by
# systemd, so they do not need an execute bit.
#
# Safe to re-run. Requires root.

set -u

NODE_USER="${NODE_USER:-pinodexmr}"
WEB_USER="${WEB_USER:-www-data}"
HOME_DIR="${HOME_DIR:-/home/$NODE_USER}"
WEB_ROOT="${WEB_ROOT:-/var/www/html}"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root (use sudo)." >&2
  exit 1
fi
if ! id "$NODE_USER" >/dev/null 2>&1; then
  echo "User '$NODE_USER' does not exist." >&2
  exit 1
fi
if ! id "$WEB_USER" >/dev/null 2>&1; then
  echo "User '$WEB_USER' does not exist." >&2
  exit 1
fi

# A shared group lets the node account and the web account cooperate on the
# few files the console updates, without granting world access to anything.
SHARE_GROUP="${SHARE_GROUP:-pinodeweb}"
getent group "$SHARE_GROUP" >/dev/null 2>&1 || groupadd "$SHARE_GROUP"
id -nG "$NODE_USER" | tr ' ' '\n' | grep -qx "$SHARE_GROUP" || usermod -aG "$SHARE_GROUP" "$NODE_USER"
id -nG "$WEB_USER"  | tr ' ' '\n' | grep -qx "$SHARE_GROUP" || usermod -aG "$SHARE_GROUP" "$WEB_USER"

echo "Applying least-privilege permissions..."

# 1. Home directory: traversable by the web user, not world-writable.
chown "$NODE_USER":"$NODE_USER" "$HOME_DIR"
chmod 755 "$HOME_DIR"

# 2. Remove world-write from the whole tree, then re-grant narrowly below.
#    (-R here is the point: it undoes the historic `chmod 777 -R`.)
chmod -R o-w "$HOME_DIR"

# 3. variables/: the console creates and rewrites fragments here, so the
#    directory itself is group-writable (setgid keeps the group on new files).
if [ -d "$HOME_DIR/variables" ]; then
  chown -R "$NODE_USER":"$SHARE_GROUP" "$HOME_DIR/variables"
  chmod 2770 "$HOME_DIR/variables"
  find "$HOME_DIR/variables" -type f -exec chmod 660 {} +
fi

# 4. execScripts/: the console only ever rewrites moneroCustomNode.sh. Keep the
#    directory non-group-writable so the web user cannot touch the other node
#    start-up scripts (p2pool.sh, moneroPrivate.sh, ...), and expose just that
#    one file to it. save-custom.php falls back to an in-place write when it
#    cannot create a temp file in the directory.
if [ -d "$HOME_DIR/execScripts" ]; then
  chown -R "$NODE_USER":"$NODE_USER" "$HOME_DIR/execScripts"
  # g-s explicitly: some filesystems retain a previously-set setgid bit even
  # when an absolute mode is applied.
  chmod g-s "$HOME_DIR/execScripts"
  chmod 755 "$HOME_DIR/execScripts"
  find "$HOME_DIR/execScripts" -type f -exec chmod 644 {} +
  CUSTOM="$HOME_DIR/execScripts/moneroCustomNode.sh"
  [ -f "$CUSTOM" ] || { printf '#!/bin/bash\n' > "$CUSTOM"; }
  chown "$NODE_USER":"$SHARE_GROUP" "$CUSTOM"
  chmod 660 "$CUSTOM"
fi

# 5. Web root: owned by the web user; scripts are served, not executed as files.
if [ -d "$WEB_ROOT" ]; then
  chown -R "$WEB_USER":"$WEB_USER" "$WEB_ROOT"
  find "$WEB_ROOT" -type d -exec chmod 755 {} +
  find "$WEB_ROOT" -type f -exec chmod 644 {} +
fi

# 6. Apache vhost stays root-owned and not world-writable.
VHOST=/etc/apache2/sites-enabled/000-default.conf
if [ -f "$VHOST" ]; then
  chown root:root "$VHOST"
  chmod 644 "$VHOST"
fi

# 7. Blockchain data: the node user only.
if [ -d "$HOME_DIR/.bitmonero" ]; then
  chown -R "$NODE_USER":"$NODE_USER" "$HOME_DIR/.bitmonero"
  chmod -R o-rwx "$HOME_DIR/.bitmonero"
fi

# 8. Wallet / atomic-swap material: the node user only, no group or other access.
if [ -d "$HOME_DIR/.atomicswap" ]; then
  chown -R "$NODE_USER":"$NODE_USER" "$HOME_DIR/.atomicswap"
  chmod -R go-rwx "$HOME_DIR/.atomicswap"
fi

# 9. RPC credentials must not be world-readable.
for f in "$HOME_DIR/variables/RPCu.sh" "$HOME_DIR/variables/RPCp.sh"; do
  [ -f "$f" ] || continue
  chown "$NODE_USER":"$SHARE_GROUP" "$f"
  chmod 640 "$f"
done

echo "Done. Summary:"
printf '  %-34s %s\n' "$HOME_DIR" "$(stat -c '%U:%G %a' "$HOME_DIR")"
for d in "$HOME_DIR/variables" "$HOME_DIR/execScripts" "$WEB_ROOT"; do
  [ -d "$d" ] && printf '  %-34s %s\n' "$d" "$(stat -c '%U:%G %a' "$d")"
done
echo "Note: restart apache2 so the web user picks up its new group membership:"
echo "  sudo systemctl restart apache2"
