# VPN Design — LogiCorp Gateway (WireGuard)

## 1. Why WireGuard

WireGuard only replies to a valid encrypted handshake from a known key. Anyone else gets no response at all — the port looks closed from outside. This is safer than exposing SSH directly, which always answers whoever connects (G2/G7).

## 2. Topology

Star topology. The gateway is the only hub (`wg0`). Each remote person (admin, Finance worker) is a separate peer with their own key. Peers never talk to each other directly — only through the gateway, where the firewall decides what happens next.

## 3. IP addressing

| Address | Role |
|---|---|
| `10.10.10.1` | Gateway (`wg0`) |
| `10.10.10.2` | Admin / consultant |
| `10.10.10.3` | Remote Finance worker |
| `10.10.10.4–49` | Reserved for future admins |
| `10.10.10.50+` | Reserved for future business peers |

## 4. Access control

Being on the VPN is not enough by itself — the firewall (`FIREWALL_POLICY.md`) still decides what each peer can reach:

- Admin (`10.10.10.2`) → LAN host `10.30.30.50`, SSH only
- Finance worker (`10.10.10.3`) → FTP server `10.20.20.10`, FTP only

Neither peer can reach the database.

## 5. Legacy FTP handling

The client will not replace the FTP workflow, and FTP itself cannot be made to encrypt anything. So instead of changing the protocol, we contain it:

- The FTP server moves to its own DMZ host and is no longer reachable directly from the internet.
- The remote Finance worker reaches it only through the VPN tunnel — so the session is encrypted end-to-end between their laptop and the gateway, and only the short internal hop (gateway → DMZ host) stays plaintext FTP.
- The DMZ host has no route to the database, so a compromised FTP server still can't reach it.

**Risk accepted:** cleartext FTP on that one internal hop, and no MFA on the FTP login itself. Accepted at the client's request, since the legacy finance software cannot be replaced right now.

## 6. Key management

- Each device generates its own key pair; private keys never leave the device.
- One key per person per device — no shared keys.
- Removing a peer's key from the gateway config is how access gets revoked (WireGuard has no separate revocation step).
