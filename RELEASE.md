# Release Runbook

This is the canonical release process for Study Triage+.

## 1) Preconditions
- Work only from the current release source-of-truth folder.
- Ensure tests pass locally.
- Ensure `manifest.json` version is the intended release version.

## 2) Validate Release Tree
Run from repository root:

```bash
bash release_gate.sh
```

This checks:
- compile/syntax
- tests
- package shape
- no duplicate runtime tree
- no quiz artifacts
- no runtime mutable files in package

## 3) Build `.ankiaddon`
From repo root:

```bash
bash scripts/build_release.sh
```

Output is written to `releases/<version>/` and root-level convenience output.

## 4) Smoke Test in Local Anki
- Sync to local live add-on folder:

```bash
bash scripts/sync_local.sh
```

- Restart Anki
- Verify:
  - opens without duplicate loading popup
  - Utilities actions work
  - Filtered tags behavior works
  - Review mode status + summary work

## 5) Publish
- Upload the built `.ankiaddon` to AnkiWeb.
- Post `What’s New` from `releases/<version>/WHATS_NEW.md`.
- Tag the release in git as `v<version>`.

## 6) Post-release Checks
- Confirm one update cycle does not wipe user settings/state.
- Watch first bug reports for regressions.
