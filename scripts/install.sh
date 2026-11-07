#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
source_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for name in start.sh tunnel.sh; do
    if [[ -e "$HOME/$name" || -L "$HOME/$name" ]]; then
        printf 'Existing %s: back it up and review it before installing. No scripts copied.\n' "$HOME/$name" >&2
        exit 1
    fi
done
mkdir -p "$HOME/server/"{www,uploads,data,apps,logs}
for name in start.sh tunnel.sh; do
    install -m 700 "$source_dir/scripts/$name" "$HOME/$name"
done
printf 'Installed scripts. Configure ~/token.txt locally, then run bash ~/start.sh.\n'
printf 'Boot setup is a separate step: see docs/startup.md.\n'
