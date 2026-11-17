# 🏗️ CyberOps (cyanide.db) — System Architecture & Security Spec

## 1. Threat Model: Active Defense vs. Passive Defense
Passive defenses (firewalls, rate limiters) allow Black Box attackers—intruders with zero internal knowledge of the system—infinite anonymous attempts to probe for vulnerabilities. CyberOps uses **Deception-as-a-Service (DaaS)** to deploy Honeypots and Canary Tokens where 100% of incoming traffic is unauthorized.

## 2. Multi-Tenant Free-Tier Quota Rules
* **Project Quota:** Maximum 5 active projects per authenticated user.
* **Trap Quota:** Maximum 3 active traps per project (1 Web Bait/SQLi Snippet, 1 Canary PDF, 1 Fake `.env` API Key).
* **Log Retention:** Stores the latest 500 breach events per user to stay within the 500 MB Supabase PostgreSQL free limit.

## 3. Functional Requirements (FR)
* **FR-01 (User Auth):** Authenticate via Supabase Auth using JWT and OAuth; protect `/dashboard` via Next.js Middleware.
* **FR-02 (Quota Enforcement):** Reject project creation requests once a user reaches 5 active projects.
* **FR-03 (True IP Extraction):** Extract client IP via `X-Forwarded-For` header first (to bypass cloud load-balancer IPs on Render) with a fallback to `request.client.host`.
* **FR-04 (SQLi Detection):** Inspect `/admin-login` payloads for SQLi signatures (`' OR 1=1`, `UNION SELECT`, `admin'--`) in memory and tag logs as `CRITICAL: SQLi`.
* **FR-05 (OSINT Enrichment):** Query `ip-api.com` asynchronously (<3s timeout) for City, Country, ISP, Latitude, and Longitude.
* **FR-06 (Real-Time Push):** Stream new PostgreSQL breach rows to the Next.js dashboard via Supabase Realtime WebSockets.
* **FR-07 (Canary Pixel):** Serve a 43-byte `1x1` transparent GIF (`image/gif`) with `Cache-Control: no-store` headers on `/canary-ping`.

## 4. Non-Functional Requirements (NFR)
* **NFR-01 (Latency):** Trap endpoints must respond in <500ms.
* **NFR-02 (Database Security):** Use Parameterized Queries / ORM bindings so attacker SQLi payloads are stored strictly as inert text.
* **NFR-03 (Rate Limiting):** Cap repeated requests at 10 req/min per IP to protect OSINT API quotas.
