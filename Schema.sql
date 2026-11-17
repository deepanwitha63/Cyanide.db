-- CyberOps (cyanide.db) - Supabase PostgreSQL Schema (SDLC Phase 2)

-- 1. Projects Table (Max 5 per user enforced via backend FR-02)
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    domain_url VARCHAR(255),
    client_token VARCHAR(64) UNIQUE NOT NULL,
    discord_webhook_url TEXT,
    is_breached BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Traps Table (Max 3 per project: 'web_bait', 'canary_pdf', 'fake_env')
CREATE TABLE IF NOT EXISTS traps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    trap_type VARCHAR(50) NOT NULL,
    endpoint_path VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Hacker Logs Table (Forensic Audit Vault)
CREATE TABLE IF NOT EXISTS hacker_logs (
    id BIGSERIAL PRIMARY KEY,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    trap_type VARCHAR(50) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    payload_captured TEXT,
    is_sqli BOOLEAN DEFAULT FALSE,
    user_agent TEXT DEFAULT 'Unknown',
    device_signature VARCHAR(100) DEFAULT 'Unknown Device',
    city VARCHAR(100) DEFAULT 'Unknown',
    country VARCHAR(100) DEFAULT 'Unknown',
    isp VARCHAR(150) DEFAULT 'Unknown',
    lat DOUBLE PRECISION DEFAULT 0.0,
    lon DOUBLE PRECISION DEFAULT 0.0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
