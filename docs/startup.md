# Automatic startup and reconnection

## Install

From the repository root in Termux:

```bash
pkg install openssh cloudflared procps util-linux -y
bash scripts/install.sh
nano ~/token.txt
chmod 600 ~/token.txt
bash ~/start.sh
```

Put only your real tunnel token on one line in `token.txt`. The installer refuses to replace existing `~/start.sh` or `~/tunnel.sh`; back up and review your existing versions before moving them aside and retrying. It does not create or modify the token.

`start.sh` creates logs, requests a wake lock, starts SSH if needed and launches the tunnel supervisor. `tunnel.sh` holds a `flock` lock for its lifetime and retries after cloudflared exits, with a ten-second delay. Re-running start is safe for this managed supervisor. An independently started cloudflared or older tmux tunnel must be stopped separately before using these scripts.

A successful launch message means the supervisor was requested. Check logs and the Cloudflare dashboard to verify connectivity. Missing tokens leave local SSH available. The supervisor does not monitor an API, website or SSH after startup, and cannot survive Android terminating Termux.

## Configure Termux:Boot

Install Termux:Boot from the same source as Termux and open it once. From the repository root:

```bash
mkdir -p ~/.termux/boot
```

Inspect any existing boot scripts first. If `00-start-server` already exists, back it up and compare it before copying:

```bash
cp -i termux/00-start-server ~/.termux/boot/00-start-server
chmod 700 ~/.termux/boot/00-start-server
```

This boot entry calls only `start.sh`. Remove redundant launches from other boot scripts after reviewing them. Do not start tunnel.sh separately at boot.

Restart the phone, unlock it once and allow a few minutes. Verify the connector and an actual SSH connection. Recheck battery restrictions if boot startup fails.

## Logs and checks

```bash
pgrep -a sshd
pgrep -a cloudflared
tail -n 40 ~/server/logs/startup.log
tail -n 40 ~/server/logs/tunnel-startup.log
tail -n 40 ~/server/logs/cloudflared.log
```

Logs are not automatically rotated; review disk use and archive old logs as needed. Lock files remain on disk normally; the active operating-system lock prevents duplicates, rather than file existence.

## Updating scripts

Pull repository updates, compare changed scripts with your installed copies, and back up the installed copies before replacing them. Pulling changes alone does not update `~/start.sh` or `~/tunnel.sh`. Stop the old managed supervisor before replacing/relaunching it; otherwise it keeps executing its previous script. Do this locally or through Tailscale so stopping Cloudflare does not remove your only recovery connection.
