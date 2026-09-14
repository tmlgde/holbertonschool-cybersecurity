Executive Summary: 
[A brief overview of the "ApexVault" security philosophy.]

1. Authentication Strategy:

Unlike a password or an SMS code, which a user can mistakenly enter on a fake site, a hardware token never transmits a reusable secret: it cryptographically verifies the domain and refuses to respond if the site isn't legitimate. Phishing therefore becomes practically impossible, unlike SMS, which remains vulnerable to social engineering.

2. Authorization Model:

Model Selected: Mandatory Access Control (MAC), enforced via SELinux — access rules are defined by a central policy that even the root user cannot override or reconfigure without a separate authorization process.

Admin Restriction: Client files are encrypted client-side before upload, with decryption keys never stored on the server. Even with full root access, the SysAdmin only sees encrypted blobs — reading the actual content is mathematically impossible without the client-held key. SELinux/MAC policies add a secondary enforcement layer restricting server-side processes from ever touching key material.

3. Accounting Architecture:

Storage Location: Logs are shipped in real time to a centralized SIEM, physically and logically separate from every production server — including the Trading Server itself. Even if an attacker gains full root access to a compromised machine, they have no reach into the SIEM.

Integrity Mechanism: Log storage uses WORM (Write Once, Read Many) — entries can be appended but never modified or deleted after being written, even by administrators. Each entry is additionally hash-chained to the previous one, so tampering with any past record breaks the chain and is immediately detectable.
