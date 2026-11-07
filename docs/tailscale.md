# Optional Tailscale backup

This section extends the source document, which included only a Tailscale heading. It uses the Android Tailscale app to reach Termux's existing OpenSSH service.

1. Install the official Tailscale Android app on the server phone and sign in.
2. Install Tailscale on your Windows laptop or second phone and sign into the same tailnet.
3. Enable the VPN connection on the server and client. Check that both devices appear online in Tailscale.
4. In Termux, run `whoami` and `sshd` (or `bash ~/start.sh`).
5. Read the server phone's Tailscale IP from the app/device list. Use it in the following command:

```powershell
ssh -p 8022 YOUR_TERMUX_USER@100.x.y.z
```

Replace the placeholder IP. In WinSCP, use SFTP, that IP, port 8022 and your Termux credentials. Tailnet policy must allow this connection. Verify the host fingerprint and keep the phone's Tailscale app allowed to run in the background.

This uses ordinary OpenSSH over Tailscale. You do not need to enable the separate Tailscale SSH feature. Android's VPN restrictions may conflict with another active VPN; check the app settings and test your own setup.

## Recovery test

While physically near the phone, first establish Tailscale SSH. Temporarily stop only your Cloudflare tunnel using its local terminal, then confirm Tailscale SSH still works. Restart the tunnel and verify Cloudflare recovery. Avoid broad process-kill commands that may terminate unrelated services.

If the phone is online over Tailscale but the tunnel has failed, inspect the Cloudflare logs and run `bash ~/start.sh` if the supervisor is no longer running. Invalid tokens, DNS or Access policy errors need their own fixes. If the phone has no internet or power, neither remote route will work; recover locally.

References: [Android installation](https://tailscale.com/docs/install/android), [Tailscale SSH feature](https://tailscale.com/docs/features/tailscale-ssh).
