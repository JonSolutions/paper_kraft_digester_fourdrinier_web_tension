-- [Fennoscandian Pulp & Paper Mill Automation & Web-Handling Drive Systems]
-- Architecture Paradigm: COUPLED_WEB_TENSION_CASCADE
-- Standard: TAPPI-T236-ISO-536-PAPTAC-QCS-2026 | Revision 01

BEGIN TRANSACTION;

CREATE SCHEMA IF NOT EXISTS paper_kraft_dige_domain;
CREATE SCHEMA IF NOT EXISTS paper_kraft_dige_rollup;

-- Entity 1: IsothermalCookingZone (COUPLED_WEB_TENSION_CASCADE)
CREATE TABLE IF NOT EXISTS paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    entry_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    station_code VARCHAR(56) NOT NULL,
    captured_epoch_ms BIGINT NOT NULL,
    operating_mode VARCHAR(40) NOT NULL DEFAULT 'STEADY_NOMINAL',
    vroom_h_factor_accum DOUBLE PRECISION NOT NULL,
    blowline_kappa_number DOUBLE PRECISION NOT NULL,
    estimator_residual DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    normalized_z_score DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    trip_breaker_engaged BOOLEAN NOT NULL DEFAULT FALSE,
    audit_digest_sha256 VARCHAR(96) NOT NULL,
    attributes_json JSONB NOT NULL DEFAULT '{}'::jsonb,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_kamyr_continuous_digest_r1_ts CHECK (captured_epoch_ms > 0),
    CONSTRAINT ck_kamyr_continuous_digest_r1_z CHECK (normalized_z_score >= 0.0)
);

CREATE INDEX IF NOT EXISTS ix_kamyr_continuous_digest_r1_station_ts
    ON paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1
    (station_code, captured_epoch_ms DESC);

CREATE INDEX IF NOT EXISTS ix_kamyr_continuous_digest_r1_breaker
    ON paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1
    (operating_mode, trip_breaker_engaged)
    WHERE trip_breaker_engaged = TRUE;

CREATE OR REPLACE VIEW
    paper_kraft_dige_rollup.vw_kamyr_continuous_digest_r1_kpi AS
SELECT
    station_code,
    operating_mode,
    COUNT(*) AS total_frames,
    AVG(vroom_h_factor_accum) AS avg_vroom_h_factor_accum,
    STDDEV_POP(vroom_h_factor_accum) AS sd_vroom_h_factor_accum,
    AVG(blowline_kappa_number) AS avg_blowline_kappa_number,
    MAX(normalized_z_score) AS peak_z_score,
    SUM(CASE WHEN trip_breaker_engaged THEN 1 ELSE 0 END) AS breaker_trips
FROM paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1
GROUP BY station_code, operating_mode;

CREATE OR REPLACE FUNCTION
    paper_kraft_dige_domain.fn_guard_kamyr_continuous_digest_r1()
RETURNS TRIGGER AS $$
DECLARE
    v_rel_err DOUBLE PRECISION;
BEGIN
    v_rel_err := ABS(NEW.vroom_h_factor_accum - (24.5)) / GREATEST(ABS(24.5), 1e-6);
    IF v_rel_err > 63.000000 THEN
        NEW.trip_breaker_engaged := TRUE;
        NEW.operating_mode := 'PROTECTIVE_TRIP_ACTIVE';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tg_kamyr_continuous_digest_r1
    ON paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1;
CREATE TRIGGER tg_kamyr_continuous_digest_r1
    BEFORE INSERT OR UPDATE
    ON paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1
    FOR EACH ROW
    EXECUTE FUNCTION
        paper_kraft_dige_domain.fn_guard_kamyr_continuous_digest_r1();

INSERT INTO paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    station_code, captured_epoch_ms, operating_mode,
    vroom_h_factor_accum, blowline_kappa_number, estimator_residual,
    normalized_z_score, trip_breaker_engaged, audit_digest_sha256
) VALUES (
    'STN-ISOTHE-R1-001', 1763600100200, 'DYNAMIC_LOAD_STEP',
    24.727403, 5.701135, 0.227403,
    0.6497, FALSE, 'sha256:paper_kr_kamyr_co_r1_001'
);
INSERT INTO paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    station_code, captured_epoch_ms, operating_mode,
    vroom_h_factor_accum, blowline_kappa_number, estimator_residual,
    normalized_z_score, trip_breaker_engaged, audit_digest_sha256
) VALUES (
    'STN-ISOTHE-R1-002', 1763600100400, 'HARMONIC_MITIGATION',
    24.683933, 5.694769, 0.183933,
    0.5255, FALSE, 'sha256:paper_kr_kamyr_co_r1_002'
);
INSERT INTO paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    station_code, captured_epoch_ms, operating_mode,
    vroom_h_factor_accum, blowline_kappa_number, estimator_residual,
    normalized_z_score, trip_breaker_engaged, audit_digest_sha256
) VALUES (
    'STN-ISOTHE-R1-003', 1763600100600, 'REDUNDANT_VOTING',
    24.57621, 5.685282, 0.07621,
    0.2177, FALSE, 'sha256:paper_kr_kamyr_co_r1_003'
    
);
INSERT INTO paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    station_code, captured_epoch_ms, operating_mode,
    vroom_h_factor_accum, blowline_kappa_number, estimator_residual,
    normalized_z_score, trip_breaker_engaged, audit_digest_sha256
) VALUES (
    'STN-ISOTHE-R1-004', 1763600100800, 'BOUNDARY_GUARD',
    24.441864, 5.674171, -0.058136,
    0.1661, FALSE, 'sha256:paper_kr_kamyr_co_r1_004'
);
INSERT INTO paper_kraft_dige_domain.tbl_kamyr_continuous_digest_r1 (
    station_code, captured_epoch_ms, operating_mode,
    vroom_h_factor_accum, blowline_kappa_number, estimator_residual,
    normalized_z_score, trip_breaker_engaged, audit_digest_sha256
) VALUES (
    