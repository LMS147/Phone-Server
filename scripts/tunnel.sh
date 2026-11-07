#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
umask 077
mkdir -p "$HOME/server/logs"
# The supervisor owns the lock throughout retries, preventing duplicate loops.
exec 9>"$HOME/server/logs/tunnel.lock"
flock -n 9 || exit 0
command -v cloudflared >/dev/null || { echo 'Missing cloudflared.' >&2; exit 1; }
[[ -s "$HOME/token.txt" ]] || { echo 'Missing or empty ~/token.txt.' >&2; exit 1; }
chmod 600 "$HOME/token.txt"
child=''
cleanup() {
    trap - INT TERM
    if [[ -n "$child" ]]; then
        kill "$child" 2>/dev/null || true
        wait "$child" 2>/dev/null || true
    fi
    exit 0
}
trap cleanup INT TERM
while true; do
    # Read again on every retry so a rotated token is used after reconnecting.
    # Environment variable keeps the credential out of command-line arguments.
    export TUNNEL_TOKEN="$(tr -d '\r\n' < "$HOME/token.txt")"
    [[ -n "$TUNNEL_TOKEN" ]] || { echo 'Empty tunnel token.' >&2; exit 1; }
    cloudflared tunnel --no-autoupdate run >> "$HOME/server/logs/cloudflared.log" 2>&1 &
    child=$!
    wait "$child" || true
    child=''
    unset TUNNEL_TOKEN
    echo 'Tunnel exited; retrying in 10 seconds.' >> "$HOME/server/logs/cloudflared.log"
    sleep 10 &
    child=$!
    wait "$child" || true
    child=''
done
