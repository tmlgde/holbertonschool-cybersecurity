1.System Information
Regarding the OS, the system runs Ubuntu 22.04.5 LTS (Jammy). The kernel was compiled recently, and its version is 6.1.177. This version is still officially supported today.
One thing that immediately stands out is the hostname: 2d61e54410044696aca6642d654069f4-2377118072. This does not look like a business-named machine built for a company.
The uptime shows the server has only been running for a few minutes (14 minutes exactly). This tells us how long the machine has been up since its last boot.
Combining these last two data points suggests that the server restarts at the beginning of each lab session.


2.Network Topology
We can identify several network interfaces:

-lo (loopback): this interface only allows the machine to talk to itself. Nothing alarming here.
-eth0@if5 has the address 169.254.172.2/22. This address range (169.254.x.x) lets a machine auto-assign itself a fallback address so it stays reachable on the local network when no DHCP server responds. The @if5 notation shows that this interface is paired with another interface across a network namespace boundary (a veth pair), consistent with the "Containers on Demand" platform hosting this lab.
-eth1 has the address 10.42.199.6/16. This is simply the IP address used to reach the lab.

Compared with Document C, this data shows that nothing sits on the 192.168.1.x subnet described there — no interface carries an address in that range.

The default route out to the outside world goes through eth1, not eth0.

The blackhole 169.254.169.254 entry shows that any packet sent to that address is automatically dropped. The container hosting platform deliberately blocks access to this address to prevent users from accessing sensitive metadata about the underlying infrastructure.

The routes toward 169.254.170.2 and 169.254.172.1 via eth0 stay entirely within the same network interface — this is also an interface isolated by the container. This confirms that eth1 is the only interface with a default route out, not eth0 as stated in Document D.

We identified several network interfaces:

lo (loopback): this interface only allows the machine to talk to itself. Nothing alarming here.
eth0@if5 has the address 169.254.172.2/22. This address range (169.254.x.x) lets a machine auto-assign itself a fallback address so it stays reachable on the local network when no DHCP server responds. The @if5 notation shows that this interface is paired with another interface across a network namespace boundary (a veth pair), consistent with the "Containers on Demand" platform hosting this lab.
eth1 has the address 10.42.199.6/16. This is the IP address used to reach the lab.

Compared with Document C, this data shows that nothing sits on the 192.168.1.x subnet described there — no interface carries an address in that range.

The default route out to the outside world goes through eth1, not eth0. The blackhole 169.254.169.254 entry shows that any packet sent to that address is automatically dropped: the container hosting platform deliberately blocks access to this address to prevent users from accessing sensitive metadata about the underlying infrastructure. The routes toward 169.254.170.2 and 169.254.172.1 stay entirely within eth0, confirming this interface is isolated within the container's own namespace. This confirms that eth1 is the only interface with a default route out, not eth0 as stated in Document D.


3.Attack Surface
s -tulnp (no sudo available) showed 5 listening ports:

Port 22/tcp (SSH) and Port 21/tcp (FTP), both open on all interfaces. This matches the gaps already listed in Document C.
Port 3000/tcp and Port 3001/tcp — not mentioned anywhere in the documentation. Process names weren't visible without sudo, so both were probed with curl:
Port 3001 identified itself as ttyd, a web-based terminal tool, protected by HTTP Basic Auth (401 response).
Port 3000 returned a generic 405 error with no identifying header.
Both ports are likely part of the "Containers on Demand" hosting platform rather than LogiCorp's own setup, but this is a probable explanation, not a confirmed fact.

4.Security Controls
No firewall was found active. nft list ruleset required a password we don't have, but an external nmap scan showed only "open" and "closed" ports — never "filtered". A default-deny firewall would show filtered ports, so this confirms Document C: no firewall is running.

sestatus returned "command not found" — SELinux isn't installed, which is normal for Ubuntu.

AppArmor couldn't be checked either: systemctl doesn't work (no systemd in this container), and the kernel parameter file for AppArmor doesn't exist. No Mandatory Access Control system could be confirmed as active.

5.User Accounts
/etc/passwd lists mostly standard Ubuntu system accounts (daemon, www-data, systemd-*, etc.) — nothing unusual there. One account stands out: telnetd, which isn't mentioned anywhere in the documentation. However, port 23 (Telnet) never appeared in our ss or nmap scans, so this account is dormant, not an active exposed service.

groups student shows the account belongs only to its own personal group, not to sudo. This means the account has no admin rights through the standard mechanism, even with a password — consistent with a least-privilege access model for an external audit account.

~/.ssh/authorized_keys contains a single ssh-ed25519 key (a modern, strong algorithm), tied to a personal identity rather than a generic/shared key. This is a solid security practice, in contrast to the other gaps found so far.

7.Scheduled Tasks

/etc/crontab and /etc/cron.d/ contain the standard Debian/Ubuntu maintenance jobs (hourly/daily/weekly/monthly run-parts, filesystem checks) — nothing concerning there.

One entry stands out: /etc/cron.d/logicorp contains * * * * * root /usr/bin/curl http://192.168.1.200/ping, run as root every minute. 192.168.1.200 falls within the exact subnet Document C describes as LogiCorp's flat network — yet our routing table (Section 2) has no route to that subnet, meaning this request fails every single time it runs. The filename itself ("logicorp") and an embedded comment (FLAG{CR0N_B4CKD00R}) confirm this is an intentional finding: a cron-based backdoor / beacon mechanism, consistent with attacker persistence that survived the backup restoration mentioned in Document A. This is one of the most critical findings of the entire audit.

8.Discrepancies

Document C's technical specifications proved accurate for every point we could directly test. SSH listens on all interfaces, confirming it is exposed to the entire network as described. FTP (vsftpd) also listens on all interfaces, confirming the cleartext legacy app gap. The nmap scan showed no filtered ports at all, only open or closed, confirming no firewall is active. The claim of a flat network on 192.168.1.x could not be fully tested, since this lab only provides a single machine rather than a simulated multi-host network — no interface here carries an address in that range.

Document D's As-Is diagram, on the other hand, got something wrong: it claims eth0 is the WAN interface, but our routing table shows the default route actually goes through eth1. eth0's traffic stays entirely within an isolated, container-internal address range and plays no WAN role at all. This confirms the Project Manager's warning that the diagram was "likely wrong."

Two findings appear nowhere in the documentation at all. First, a telnetd account exists on the system, though no service is currently listening on port 23 — a dormant leftover rather than an active gap. Second, and far more serious, a cron job in /etc/cron.d/logicorp runs every minute as root, beaconing to 192.168.1.200. Its filename and an embedded flag confirm this is an intentional finding: a backdoor-style persistence mechanism, consistent with an attacker foothold that survived the backup restoration mentioned in Document A. This is the most critical discrepancy of the entire audit — none of the client's documentation hints that the original compromise might not have been fully removed.
