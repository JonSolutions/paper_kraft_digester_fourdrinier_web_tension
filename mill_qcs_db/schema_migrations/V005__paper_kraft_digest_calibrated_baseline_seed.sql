-- [Fennoscandian Pulp & Paper Mill Automation & Web-Handling Drive Systems]
-- Architecture Paradigm: COUPLED_WEB_TENSION_CASCADE
-- Standard: TAPPI-T236-ISO-536-PAPTAC-QCS-2026 | Revision 05

BEGIN TRANSACTION;

CREATE SCHEMA IF NOT EXISTS paper_kraft_dige_domain;
CREATE SCHEMA IF NOT EXISTS paper_kraft_dige_rollup;

-- Entity 1: SmeltRecoveryBoiler (COUPLED_WEB_TENSION_CASCADE)
CREATE TABLE IF NOT EXISTS paper_kraft_dige_domain.tbl_tomlinson_recovery_boil_r5 (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    station_code VARCHAR(56) NOT NULL,
    captured_epoch_ms BIGINT NOT NULL,
    operating_mode VARCHAR(40) NOT NULL DEFAULT 'STEADY_NOMINAL',
    sulfidity_white_liquor DOUBLE PRECISION NOT NULL,
    reduction_efficiency_pct DOUBLE PRECISION NOT NULL,
    estimator_residual DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    normalized_z_score DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    trip_breaker_engaged BOOLEAN NOT NULL DEFAULT FALSE,
    audit_digest_sha256 VARCHAR(96) NOT NULL,
    attributes_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_tomlinson_recovery_boil_r5_ts CHECK (captured_epoch_ms > 0),
    CONSTRAINT ck_tomlinson_recovery_boil_r5_z CHECK (normalized_z_score >= 0.0)
);

CREATE INDEX IF NOT EXISTS ix_tomlinson_recovery_boil_r5_station_ts
    ON paper_kraft_dige_domain.tbl_tomlinson_recovery_boil_r5
    (station_code, captured_epoch_ms DESC);

CREATE INDEX IF NOT EXISTS ix_tomlinson_recovery_boil_r5_breaker
    ON paper_kraft_dige_domain.tbl_tomlinson_recovery_boil_r5
    