# Study Triage+ (Anki Add-on)

Study Triage+ is built to answer one question: **what should I study next from my misses?**

It turns revlog + missed-card noise into actionable triage, supports temporary review-mode exclusions, and helps you jump straight to relevant resources.

## What It Does

### 1) Missed Tab
- Finds and ranks missed topics by weighted impact.
- Surfaces high-priority weak areas instead of raw miss lists.

### 2) Resource Mapping
- Maps triaged topics to linked resources.
- Supports quick “suggest similar” and resource navigation workflows.

### 3) Review Modes
- **Grace Period** and **Learn Mode** let you temporarily ignore specific misses during focused sessions.
- Tracks ignored misses and session windows for visibility.

### 4) Study Log + Utilities
- Save and revisit recommended topics.
- Manage resources and filtered tags directly from Utilities/Settings.

### 5) Progress
- Readable progress trends from revlog, grouped by subdeck (works best if your deck is organized into subdecks).

---

## Install

### Recommended
- Install/update through **AnkiWeb**.

### Local package install
1. Install the latest `.ankiaddon` release package.
2. Restart Anki.

---


## Compatibility

- Supports modern Anki builds with **Qt5 and Qt6** compatibility handling.
- Qt/Anki compatibility differences are centralized in:
  - `study_triage/compat/`

---

## Resource Index (v3)

- Expects `resource_link_index.sqlite` schema version `3`.
- Preferred source: Resource Indexer output (add-on ID `1883561870`).
- Bundled fallback index path:
  - `data/resource_link_index.sqlite`
- If index is missing/invalid, Resources tab shows an actionable error.

---

## Configuration

- Stored per profile via Anki add-on config.
- Normalized/validated on load to prevent broken states.
- Full config contract:
  - `docs/config.md`

---

## Project Layout

- `__init__.py` — thin entrypoint, delegates to `study_triage.main`
- `study_triage/main.py` — app wiring, hooks, menu/actions, orchestration
- `study_triage/compat/` — Qt/Anki compatibility layer
- `study_triage/core/` — core logic (reporting, config, review mode, study log)
- `study_triage/persistence/` — SQLite/resource index persistence
- `study_triage/ui/` — UI components/dialog rendering
- `study_triage/editor/` — editor integrations (filtered tags, hook-driven UI)
- `study_triage/util/` — logging/path helpers
- `tests/` — automated tests
- `scripts/` — release, validation, and local sync helpers
- `releases/` — release artifacts and notes

---

## Troubleshooting / Bug Reports

From Settings:
- Use **Report a Bug** to copy diagnostics and open log location.

Useful info to include in bug reports:
- Exact click path
- Expected vs actual behavior
- Anki version + Qt version
- Relevant `study_triage.log` lines

Log file:
- `study_triage.log` (stored in add-on user data dir when available)

If Resources is empty:
- Re-run Resource Indexer to regenerate the DB.

---

## Disclaimer
This add-on is not affiliated with or endorsed by AnKing, Anki, or third-party resource providers.
It does not distribute deck content/media; it maps links/media names already present in the user’s own environment.
Users are responsible for compliance with applicable licenses and terms.

