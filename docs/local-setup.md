# Local setup

## Prepare Android

Connect the phone to Wi-Fi, install available OS updates and free approximately 10 GB of storage. Remove previous owners' Google/Samsung accounts before considering a factory reset.

Install F-Droid from https://f-droid.org/, then install Termux and Termux:Boot from the same source. Open both once. In Samsung settings, set both apps to **Unrestricted** battery usage, add them to **Never sleeping apps**, allow notifications and disable Power Saving while serving. Menu names vary by Android version.

## Install tools

In Termux:

```bash
pkg update && pkg upgrade -y
pkg install openssh python git nano curl procps cloudflared util-linux -y
termux-wake-lock
mkdir -p ~/server/{www,uploads,data,apps,logs}
passwd
whoami
sshd
```

Record the username from `whoami`. Password entry is invisible. Find the phone's LAN IP under Android Wi-Fi network details, for example `192.168.1.50`.

## Connect from Windows

Connect the laptop to the same reachable network. In PowerShell, replace the example IP and username:

```powershell
Test-NetConnection 192.168.1.50 -Port 8022
ssh -p 8022 YOUR_TERMUX_USER@192.168.1.50
```

Expect `TcpTestSucceeded : True`. Verify the SSH host fingerprint before accepting a new host; on the phone use `ssh-keygen -lf "$PREFIX/etc/ssh/ssh_host_ed25519_key.pub"`.

For file transfers, use WinSCP with **SFTP**, the phone IP, port **8022**, the Termux username and password. Remote folders are under `/data/data/com.termux/files/home/server/`: `www` for website files, `uploads` for private files, `data` for application data. Keep private files outside the web root.

## Test the website

After cloning this repository, from its root:

```bash
cp examples/index.html ~/server/www/index.html
python -m http.server 8080 --bind 0.0.0.0 --directory ~/server/www
```

Open `http://192.168.1.50:8080` on the laptop. Keep this terminal open; press Ctrl+C to stop. Binding all interfaces exposes this test server to reachable LAN/VPN peers. It provides neither authentication nor production hardening. A working homepage verifies HTTP only, not an API or database.
