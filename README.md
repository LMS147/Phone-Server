# Phone Server

Turn an Android phone into a small server using Termux, OpenSSH and Cloudflare Tunnel. Based on the supplied **How to create a server using a phone** guide, with corrected scripts and organised instructions.

Use a Samsung Galaxy A12 or another compatible Android phone for local SSH, SFTP uploads, a demonstration website, and remote administration. No root access or router port forwarding is required for this setup.

## Start here

1. [Prepare the phone and test local access](docs/local-setup.md).
2. [Configure Cloudflare Tunnel and Access](docs/cloudflare.md).
3. [Install the scripts and enable boot startup](docs/startup.md).
4. Optionally [configure Tailscale as a backup connection](docs/tailscale.md).
5. See [troubleshooting and security](docs/troubleshooting.md) when a connection fails.

## Install the scripts

After completing the local setup:

```bash
pkg install git cloudflared util-linux -y
git clone https://github.com/LMS147/Phone-Server.git
cd Phone-Server
bash scripts/install.sh
```

The installer copies `start.sh` and `tunnel.sh` into your Termux home directory. It refuses to overwrite existing scripts. Create `~/token.txt` locally as explained in the startup guide, then run:

```bash
bash ~/start.sh
```

## What runs

| Component | Purpose | Started by start.sh? |
| --- | --- | --- |
| OpenSSH, port 8022 | Shell access and SFTP | Yes |
| Cloudflare Tunnel | Remote connection through Cloudflare | Yes, when token.txt is configured |
| Python HTTP server, port 8080 | Temporary website demonstration | No; start manually |
| Your API, bot or database | Your own application | No; add separately |
| Tailscale Android app | Independent private network route | Managed in the Android app |

Scripts live directly under `~/`; websites, uploads, application data and logs live in `~/server/`. The repository is the source of the scripts, rather than the live server data directory.

## Files

| Path | Contents |
| --- | --- |
| `scripts/` | Installer, SSH startup and tunnel retry scripts |
| `termux/00-start-server` | Termux:Boot entry point |
| `examples/index.html` | Demonstration homepage |
| `examples/ssh-config` | Windows/Android SSH configuration examples |
| `docs/` | Installation, access, boot and recovery guides |
| `.gitignore` | Excludes tokens, private keys, logs and runtime data |

## Limitations

Android may stop background applications. Reboot startup depends on Termux:Boot, permissions and battery settings; unlock the phone once after restarting. Remote access requires a powered-on phone with a working network. Tailscale can help when Cloudflare fails, but cannot restore power or internet connectivity.

Python's built-in HTTP server is for testing. This project does not implement a production application, a restart dashboard, backups, or automatic application deployment.

## Source and references

The uploaded Word guide is the project source. Technical corrections and the optional Tailscale instructions use these official references:

- [Termux installation](https://github.com/termux/termux-app#installation)
- [Termux:Boot](https://github.com/termux/termux-boot)
- [Cloudflare SSH with client-side cloudflared](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-cloudflared-authentication/)
- [Cloudflare browser-rendered terminal](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/browser-rendering/)
- [Tailscale for Android](https://tailscale.com/docs/install/android)
- [Tailscale SSH](https://tailscale.com/docs/features/tailscale-ssh)

The original document ends with a Tailscale heading; that guide is an added optional procedure. Hardware and remote connectivity still need verification on your own phone.
