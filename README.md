# Paper_Kraft_Digester_Fourdrinier_Web_Tension_Fullstack_Repo

Production service architecture and telemetry verification suite.

## Modules
- `mill_network/opcua_drives/paper_kraft_digest_calibration_registry.json` (315 lines)
- `mill_network/opcua_drives/paper_kraft_digest_k8s_workloads.yaml` (295 lines)
- `mill_network/opcua_drives/paper_kraft_digest_openapi_contract.yaml` (839 lines)
- `mill_network/opcua_drives/paper_kraft_digest_prometheus_alerts.yaml` (315 lines)
- `mill_qcs_db/schema_migrations/V001__paper_kraft_digest_initial_core_topology.sql` (1606 lines)
- `mill_qcs_db/schema_migrations/V002__paper_kraft_digest_partitioned_timeseries_store.sql` (1606 lines)
- `mill_qcs_db/schema_migrations/V003__paper_kraft_digest_invariant_trigger_procedures.sql` (1606 lines)
- `mill_qcs_db/schema_migrations/V004__paper_kraft_digest_materialized_kpi_rollups.sql` (1606 lines)
- `mill_qcs_db/schema_migrations/V005__paper_kraft_digest_calibrated_baseline_seed.sql` (1606 lines)
- `pulp_paper_qcs/hfactor_kappa/kamyr_continuous_digest_constitutive_law_kernel.py` (953 lines)
- `pulp_paper_qcs/hfactor_kappa/kamyr_continuous_digest_rest_command_controller.py` (953 lines)
- `pulp_paper_qcs/hfactor_kappa/sectional_draw_tension_horizon_stress_projector.py` (953 lines)

## Running Tests
```bash
pytest -v
python -m unittest discover -s tests
```
