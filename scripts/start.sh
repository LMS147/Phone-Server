#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
umask 077
mkdir -p "$HOME/server/logs"
command -v termux-wake-lock >/dev/null && termux-wake-lock || true
for tool in sshd pgrep flock; do
    command -v "$tool" >/dev/null || { printf 'Missing dependency: %s\n' "$tool" >&2; exit 1; }
done
# Serialize concurrent launches. The tunnel closes this descriptor before starting.
exec 8>"$HOME/server/logs/start.lock"
flock 8
pgrep -x sshd >/dev/null 2>&1 || sshd
if [[ ! -s "$HOME/token.txt" ]]; then
    printf 'SSH started. Tunnel skipped: create ~/token.txt with your tunnel token.\n'
    exit 0
fi
command -v cloudflared >/dev/null || { echo 'Install cloudflared first.' >&2; exit 1; }
[[ -f "$HOME/tunnel.sh" ]] || { echo 'Missing ~/tunnel.sh.' >&2; exit 1; }
nohup bash "$HOME/tunnel.sh" 8>&- >> "$HOME/server/logs/tunnel-startup.log" 2>&1 < /dev/null &
printf 'SSH available; tunnel launch requested. Inspect ~/server/logs/cloudflared.log.\n'
