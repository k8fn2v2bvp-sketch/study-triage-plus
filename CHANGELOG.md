# Changelog

All notable changes to Study Triage+ are documented here.

## 2.6.5 - 2026-04-15

### Fixed
- Removed duplicate loading popup path when opening Study Triage, significantly improving open performance.
- Restored Utilities wiring so `Resources Enabled…` and `Filtered Tags Settings…` are fully connected.
- Restored full filtered-tags runtime/editor integration and settings behavior.
- Re-enabled review mode summary flow and related diagnostics path.

### Improved
- Added filtered-tag chip readability/polish improvements (compact chip-style rendering).
- Hardened hook registration to prevent duplicate filtered-tags hook registration on reload paths.
- Reduced noisy normal-use dialog logging (debug details remain available in debug mode).
- Hardened release packaging/update flow to avoid shipping mutable runtime files.

### Release Engineering
- Confirmed package excludes mutable user runtime files (`meta.json`, logs, checkpoint/session/state files).
- Confirmed release gate coverage (compile, tests, package shape checks).

## 2.6.4
- Prior release baseline.
