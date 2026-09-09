# Firewall Policy — LogiCorp Gateway (nftables)

## 1. Default policies

| Chain | Policy | Why |
|---|---|---|
| `input` (traffic to the gateway) | drop | Nothing should reach the gateway directly except the VPN port. Fixes G2/G3 (SSH open to everyone, no firewall at all). |
| `forward` (traffic between zones) | drop | No zone can reach another zone by default. Fixes G1 — this is what would have stopped the Guest WiFi device from reaching the database. |
| `output` (traffic from the gateway) | accept | The gateway still needs to reach the internet itself, for updates. |

## 2. Rules (in order)

**input:**
1. accept established/related traffic
2. accept loopback
3. accept `udp/51820` (WireGuard) from anywhere
4. log and drop everything else

**forward:**
1. accept established/related traffic
2. admin VPN peer (`10.10.10.2`) → LAN host (`10.30.30.50`), `tcp/22` only
3. Finance VPN peer (`10.10.10.3`) → FTP server (`10.20.20.10`), `tcp/21` + `tcp/21000-21010` (FTP needs a second port range for the actual file transfer — this is normal FTP behavior, not a mistake)
4. LAN app host (`10.30.30.50`) → database (`10.40.40.2`), `tcp/3306` only
5. LAN (`10.30.30.0/24`) → internet, `tcp/80`, `tcp/443`, `udp/53`
6. Guest WiFi (`10.50.50.0/24`) → internet, `tcp/80`, `tcp/443`, `udp/53`
7. explicit log + drop: Guest → LAN, Guest → DB, DMZ → DB (already blocked by the default policy, but logged separately so we can see if anyone tries the exact incident path again)
8. log and drop everything else

## 3. Why this order

- Established/related first — it's checked on almost every packet and is required for replies to work at all.
- Specific single-host rules (VPN, DB) before the wide subnet rules (internet access), so a wide rule can never accidentally cover a narrow, sensitive one.
- The explicit deny+log rules come before the final drop, so the exact incident path gets its own clear log line instead of blending into generic noise.

## 4. What this fixes

- **G1/G6**: the database is reachable from one host, one port, nothing else.
- **G2**: no direct SSH from the internet anymore.
- **G3**: default deny on both `input` and `forward`.
- **G4**: FTP is no longer reachable directly from the internet (see `VPN_DESIGN.md`).
- **G5**: drop rules are logged, giving basic visibility that didn't exist before.
