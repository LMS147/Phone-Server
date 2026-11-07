# Remote access with Cloudflare

## Preserve existing DNS

Use a domain whose DNS is managed by Cloudflare. Before changing nameservers, export or record every existing DNS entry, including GitHub Pages A/CNAME records, GitHub ownership TXT records, MX and email SPF/DKIM/DMARC records. Recreate and verify them in Cloudflare before switching nameservers. Keep your existing GitHub Pages custom domain and `www` destination. Use a separate hostname such as `ssh.example.com` for the phone.

## Create and protect the route

1. In Cloudflare Zero Trust, create a Cloudflared tunnel and name it, for example `homessh`. Dashboard navigation can change.
2. Copy only the tunnel token from the connector command into `~/token.txt` on the phone using `nano ~/token.txt`. Never commit it or paste it into an issue.
3. Run `chmod 600 ~/token.txt`. Install and start this repository's scripts as described in [startup](startup.md).
4. Wait for the connector to become healthy. Its reported location may vary.
5. Add a published application route/public hostname: `ssh.example.com`, service **SSH**, origin `localhost:8022`. Use SSH service type for the SSH flow documented here.
6. Create a self-hosted Access application for that exact hostname. Add an Allow policy restricted to your own email, and configure an available login method such as one-time PIN. Verify an unapproved identity cannot access it.

Keep Access protection on the SSH hostname. A separate HTTP route for a website can point to `http://localhost:8080`, but that does not start the HTTP server or make it suitable for production.

## Windows SSH

Install cloudflared on the laptop:

```powershell
winget install --id Cloudflare.cloudflared
Get-Command cloudflared
```

Merge the Windows block from [the example config](../examples/ssh-config) into `C:\Users\YOURNAME\.ssh\config`. Replace the executable path, username and hostname. The executable path must be quoted if it contains spaces.

```powershell
ssh homessh
```

Complete the browser Access login, then authenticate to Termux SSH. Cloudflare Access authentication and the SSH password/key are separate checks. Network policies may still block Cloudflare; follow the network owner's rules.

## WinSCP through a local forward

In a separate laptop terminal, keep this running:

```powershell
cloudflared access tcp --hostname ssh.example.com --url 127.0.0.1:8023
```

In WinSCP select SFTP, host `127.0.0.1`, port `8023`, and the phone's Termux credentials. Verify the phone's host fingerprint.

## Connect from another Android phone

Install Termux from F-Droid, then:

```bash
pkg update && pkg install openssh cloudflared -y
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/config
```

Merge the Android block from the example config and replace its placeholders. Set `chmod 600 ~/.ssh/config`, then run `ssh phone` and complete the browser login if requested.

## Optional browser terminal

Opening the SSH URL does not automatically enable a browser terminal. Configure SSH browser rendering in the Access application's settings and check its server compatibility requirements first. Start with the native SSH method above.

Official instructions: [client-side cloudflared](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-cloudflared-authentication/) and [browser rendering](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/browser-rendering/).
