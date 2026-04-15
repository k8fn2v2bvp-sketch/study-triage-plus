# Study Triage+ (Anki Add-on)

Generate a human-readable progress report from your Anki revlog, grouped by subdeck, plus missed-card recommendations and resource exploration.

## Install
1. Copy the folder `study_triage_Release` contents into your Anki add-ons folder (or install via AnkiWeb).
2. Restart Anki.

## Use
- Open Anki.
- Go to `Tools` → `Study Triage+`.
- A dialog appears with Progress, Missed, Study Log, Resources, and Settings.

## Compatibility
- Supports both Qt5 and Qt6 Anki builds.
- All Qt/Anki differences are centralized in `study_triage/compat/`.

## Resource Index (v3)
- Study Triage expects `resource_link_index.sqlite` schema version `3`.
- Preferred source is Resource Indexer output (add-on ID `1883561870`).
- A bundled index in `data/resource_link_index.sqlite` is used as a fallback.
- If the index is missing, the Resources tab will show an actionable error message.

## Configuration
- Config is stored per Anki profile via Anki’s add-on config UI.
- See `docs/config.md` for the full configuration contract.
- Settings are normalized and validated on load.

## Project Layout
- `__init__.py`: Thin entrypoint that delegates to `study_triage.main`.
- `study_triage/main.py`: Wiring, hooks, menu registration, background tasks.
- `study_triage/compat/`: Qt and Anki API compatibility layer.
- `study_triage/core/`: Pure logic (reporting, config, resources, study log).
- `study_triage/persistence/`: SQLite access and resource index lifecycle.
- `study_triage/ui/`: Qt-only UI modules.
- `study_triage/util/`: Logging and path helpers.

## Troubleshooting
- The Settings tab includes “Report a Bug” which copies diagnostics and opens the log folder.
- Log file: `study_triage.log` (stored in the add-on user data directory when available).
- If the Resources tab is empty, re-run the Resource Indexer add-on to regenerate the index DB.

Disclaimer: This add-on is not affiliated with or endorsed by AnKing, Anki, or any resource provider. It does not include or distribute any deck content or media; it only indexes links and media filenames already present in the user's own collection. Users are responsible for ensuring their content and use comply with applicable licenses and terms.

## Development & Testing
- Run `python -m compileall .` to catch import/syntax issues.
- Canonical tests: `PYTHONPATH=. ../.venv/bin/pytest -q tests`.
- In Anki’s debug console, run `study_triage.main.smoke_check()` to verify the add-on loads and can generate a small report without freezing the UI.
- The resource index must be schema v3; bundled `data/resource_link_index.sqlite` is validated on load.
- Release layout validation: `bash ../validate_release_layout.sh`.
- Local live sync (preserves user state): `bash ../sync_release_to_live.sh`.
- Package build (allowlist + shape checks): `bash ../build_release_ankiaddon.sh`.
- See `docs/release_checklist.md` for release steps.
- See `docs/diagnostics_checklist.md` for active-code verification.
- See `docs/release_dev_contract.md` for release/dev boundaries.
