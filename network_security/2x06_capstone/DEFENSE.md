LogiCorp Gateway Project
Challenge 1: Risk Acceptance
Business constraint: Finance uploads invoices through a legacy accounting application that only speaks FTP, not SFTP. Replacing that software means migration, retraining, and vendor validation — not something that fits a one-week, don't-break-production engagement. Forcing a software change on the client is a business decision for LogiCorp, not something a security consultant imposes mid-engagement.

Risk mitigation implemented: FTP no longer touches the open Internet. The Finance peer must first authenticate through WireGuard — FTP only runs inside that already-encrypted tunnel. The firewall then scopes that VPN peer to reach only the FTP server, on only the ports FTP needs (21 and the passive range 21000-21010). The FTP server itself sits in the DMZ, and the DMZ-to-DB firewall rule explicitly denies and logs any attempt to reach the database from there — so even a compromised FTP server can't pivot inward.

Residual risk: FTP still has no built-in integrity checking or modern authentication. If the VPN tunnel or the Finance peer's key were ever compromised, the session inside would be as weak as plain FTP. This risk is accepted, not eliminated.

Recommendation for Phase 2: Migrate to SFTP or a managed file-transfer tool once LogiCorp can plan the software change. Until then, VPN + strict firewall scoping is a compensating control, not a permanent fix.


Challenge 2: Firewall Strategy
Zones and trust levels: The old network was flat — Guest WiFi, office PCs, and the database all on one segment with nothing between them. The new design splits it into six zones with decreasing trust: the untrusted WAN and Guest WiFi, the VPN zone for authenticated remote users, the DMZ for the legacy FTP server, the LAN for office PCs, and the DB-VLAN holding the database — the most sensitive zone, with the fewest allowed connections into it.

Traffic flow restrictions: Both the input and forward chains are default-deny — nothing crosses a boundary unless explicitly allowed. The only rule reaching the database lets the LAN's application server talk to it, on the database port only. No other zone has any path there at all.

How the attack path is blocked: The original breach moved from a compromised Guest device straight to the database, because nothing stood in the way. Now, Guest WiFi has no rule to reach the LAN or the DB — any attempt is denied and logged. Even the DMZ, the most exposed internal zone, is explicitly blocked from reaching the DB. And the only way in from outside at all is through WireGuard, which needs a valid key — a random Internet host, or a compromised Guest device, can't even reach the VPN zone. The flat-network shortcut that caused the breach no longer exists.

Defense in depth: No single control carries all the weight. Segmentation, a default-deny firewall, VPN-gated remote access, hardened SSH (no root login, keys only), and explicit logging on every denied path all stack together — plus cleanup of what the audit found already in place (the cron backdoor, the dormant telnetd account). If one layer is bypassed, the next one still stops the attacker before anything sensitive is reached.


Challenge 3: Resilience
Scope acknowledgment: Redundancy was explicitly marked out of scope by the client for this engagement. That was a deliberate choice, not an oversight — the one-week mandate prioritized closing the active security gaps that caused the breach over building redundant hardware.

Current risk exposure: The Gateway is the only firewall, VPN endpoint, and routing point for the network. If it goes down, VPN access and outbound connectivity for internal zones go down with it. Importantly, this is a fail-closed failure: the network becomes unreachable, not unprotected. That's the right failure mode for a security device — availability suffers, but no new security hole opens up.

Phase 2 plan: Add a second gateway in an active/passive pair (VRRP/keepalived-style), sharing a virtual IP and keeping the same nftables and WireGuard configuration synchronized, so the standby takes over automatically if the primary fails.

Cost-benefit: A second gateway means more hardware, more complexity to keep both configs in sync without drift, and more to maintain for a small IT team. LogiCorp did lose 2 days to the ransomware incident, so downtime has a real cost — but that incident was a security failure (lateral movement through a flat network), not a hardware failure, and this project already fixes that root cause. HA addresses a different, separate risk that hasn't materialized yet. Recommendation: revisit it once the current fixes are validated stable in production, rather than spending this week's limited time on it now.


