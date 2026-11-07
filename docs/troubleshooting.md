# Troubleshooting and security

| Symptom | Check or action |
| --- | --- |
| Local SSH fails | Confirm the current Wi-Fi IP, same reachable network, username and port 8022; run `sshd` on the phone. Guest Wi-Fi may isolate devices. |
| Local works, Cloudflare fails | Check connector health, token, hostname service SSH to localhost:8022, Access policy and laptop ProxyCommand path. |
| New internet connection | Wait for cloudflared to reconnect; retry SSH. LAN IP may change. Inspect logs if it remains offline. |
| Tunnel repeatedly exits | Read cloudflared.log; confirm token validity and network/DNS reachability. Rotate an exposed token. |
| Access login succeeds, SSH denied | Confirm the phone's SSH username/password or authorized key; Access login does not replace SSH authentication. |
| Browser URL has no terminal | Browser rendering requires explicit configuration and compatibility checks. Use native SSH first. |
| Website unavailable | Start the demonstration HTTP server manually; start.sh does not launch it. |
| Failure after reboot | Unlock once, verify Termux:Boot was opened, inspect startup.log and Android battery restrictions. |
| Phone offline on both routes | Check power, Wi-Fi/mobile data and Android apps locally. |
| Multiple tunnels | Stop a manually launched tmux/old tunnel before enabling this supervisor. |

## Credential handling

Keep `~/token.txt` mode 600. The tunnel reads its token via `TUNNEL_TOKEN`, so the token is not embedded in the script or process command line. Processes with sufficient local privileges can still access credentials. Keep the device secured.

Never commit real tokens, private keys, `.env` files, uploads or databases. `.gitignore` helps prevent accidental tracking but does not remove previous commits. Revoke/rotate any exposed credential immediately, then arrange history cleanup if necessary.

Prefer SSH keys after the first successful connection. Generate keys on the client, add only the public key to the phone's `~/.ssh/authorized_keys`, and test a separate session before changing password authentication. Keep private files outside `~/server/www`. Restrict Cloudflare Access and tailnet access to intended users.

Use a ventilated location and a sound charger; monitor battery health and temperature during extended use. Back up important data separately. This repository does not provide data backups or a guarantee of continuous availability.
