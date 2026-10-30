# Security Audit Report - Hardened Shield

**Date:** 2026-10-30 10:10:36

**Overall Score:** 8/12 (66.7%)

**Final Status:** FAIL


---


## Kernel Hardening (1/2)

| Check | Status |
|-------|--------|
| IP forwarding disabled (or delegated to host) | ❌ FAIL |
| SYN cookies enabled (or delegated) | ✅ PASS |

## Filesystem Security (2/2)

| Check | Status |
|-------|--------|
| /etc/shadow permissions are 600 or stricter | ✅ PASS |
| /etc/ssh directory is restricted | ✅ PASS |

## Identity Security (2/4)

| Check | Status |
|-------|--------|
| SSH password authentication disabled | ✅ PASS |
| SSH root login disabled | ✅ PASS |
| Password complexity enforced (minlen 12) | ❌ FAIL |
| Account lockout configured (deny 5) | ❌ FAIL |

## Service Security (2/2)

| Check | Status |
|-------|--------|
| Apache web server installed | ✅ PASS |
| SSH server installed | ✅ PASS |

## Container Security (1/2)

| Check | Status |
|-------|--------|
| Non-root user 'appuser' exists | ❌ FAIL |
| No exposed .env secret file | ✅ PASS |
