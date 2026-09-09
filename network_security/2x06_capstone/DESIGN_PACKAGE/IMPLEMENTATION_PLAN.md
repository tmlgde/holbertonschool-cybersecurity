# Implementation Plan — LogiCorp Gateway

Main rule: never remove an old access path until the new one is tested and working. This is what avoids locking ourselves out on a gateway that is also the only way in.

## Step 0 — Backup

Back up `sshd_config`, current firewall state, and crontab (including the cron backdoor found in the audit — keep it, we remove it on purpose in Step 6, not by accident). Confirm out-of-band console access exists as a fallback.
**Rollback:** nothing changed yet.

## Step 1 — Add WireGuard, keep old SSH open

Set up `wg0` and the admin peer. Don't touch the firewall or SSH config yet. Test SSH over the VPN from an outside network.
**Rollback:** remove the `wg0` config — nothing else was touched.

## Step 2 — Apply the firewall, with a safety net

Load the new firewall rules, but temporarily also keep direct SSH open from the current admin IP. Schedule an automatic revert in 15 minutes in case something breaks.
**Rollback:** the scheduled revert fires on its own, or reload the backup ruleset from the console.

## Step 3 — Confirm VPN SSH works, then close the gap

Test VPN SSH again, from a different network this time. Once it's reliable, remove the temporary direct-SSH rule and load the final ruleset. Harden `sshd_config`: `PermitRootLogin no`, `PasswordAuthentication no`.
**Rollback:** restore the old `sshd_config` and the step-2 ruleset from the console.

## Step 4 — Segment the database

Move the database to its own VLAN. Add the one rule allowing only the app host. Confirm the app still works, and confirm a guest-like device can no longer reach the DB.
**Rollback:** remove the new rule and temporarily move the DB back if the app breaks.

## Step 5 — Move FTP behind the VPN

Set up FTP on the new DMZ host, keep the old FTP path working in parallel. Have the Finance worker test an upload over VPN. Once confirmed, remove the old direct FTP rule.
**Rollback:** re-enable the old direct FTP path while the new one is debugged.

## Step 6 — Isolate Guest WiFi, remove the cron backdoor

Apply the guest-only-internet rules. Confirm guests still browse normally and can't reach the LAN or DB. Remove the cron backdoor job.
**Rollback:** restore the cron job from the Step 0 backup if something unexpected breaks, and investigate before retrying.

## Step 7 — Logging and final check

Confirm the drop rules are actually logged somewhere visible. Re-test the original incident path (simulated guest device → database) and confirm it is now blocked and logged.
**Rollback:** not needed — this step only verifies the previous ones.
