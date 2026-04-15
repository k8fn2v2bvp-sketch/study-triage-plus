#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$ROOT_DIR"

fail() {
  echo "[release_gate] Error: $*" >&2
  exit 1
}

[[ -d "$RELEASE_DIR/study_triage" ]] || fail "missing runtime tree"
[[ -d "$RELEASE_DIR/tests" ]] || fail "missing tests tree"
[[ -f "$RELEASE_DIR/manifest.json" ]] || fail "missing manifest.json"

runtime_count="$(find "$RELEASE_DIR" -type d -name 'study_triage' | wc -l | tr -d ' ')"
[[ "$runtime_count" == "1" ]] || fail "expected exactly 1 study_triage runtime tree, found $runtime_count"

tests_count="$(find "$RELEASE_DIR" -type d -name 'tests' | wc -l | tr -d ' ')"
[[ "$tests_count" == "1" ]] || fail "expected exactly 1 tests tree, found $tests_count"

if [[ -d "$RELEASE_DIR/study_triage_UI/study_triage" ]]; then
  fail "duplicate runtime tree found in study_triage_UI"
fi

if find "$RELEASE_DIR/study_triage" "$RELEASE_DIR/tests" -type f | grep -Eqi '/[^/]*quiz[^/]*$'; then
  fail "quiz artifacts found in release runtime/tests"
fi

echo "[release_gate] py_compile"
python3 - <<'PY'
from pathlib import Path
import py_compile
files = list(Path('study_triage').rglob('*.py')) + list(Path('tests').rglob('*.py'))
for p in files:
    py_compile.compile(str(p), doraise=True)
print(f"py_compile OK ({len(files)} files)")
PY

echo "[release_gate] pytest"
PYTHONPATH=. ../.venv/bin/pytest -q tests

# Cleanup generated artifacts to keep release tree clean.
find "$RELEASE_DIR" -type d \( -name '__pycache__' -o -name '.pytest_cache' \) -prune -exec rm -rf {} +
find "$RELEASE_DIR" -type f -name '*.pyc' -delete
rm -f "$RELEASE_DIR/study_triage.log"

if find "$RELEASE_DIR" -type d \( -name '__pycache__' -o -name '.pytest_cache' \) | grep -q .; then
  fail "generated cache directories still present after cleanup"
fi

[[ ! -f "$RELEASE_DIR/study_triage.log" ]] || fail "runtime log artifact present in release tree"

VERSION="$(python3 - "$RELEASE_DIR/manifest.json" <<'PY'
import json
import sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    print(str(json.load(f).get('version', '')).strip())
PY
)"
[[ -n "$VERSION" ]] || fail "could not parse version from manifest"

ALLOWLIST=(
  "__init__.py"
  "README.md"
  "config.json"
  "manifest.json"
  "docs"
  "study_triage"
  "tests"
)

STATIC_DATA_FILES=(
  "resource_descriptions.json"
  "resource_link_index.sqlite"
)

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/studytriage_gate.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

for item in "${ALLOWLIST[@]}"; do
  [[ -e "$RELEASE_DIR/$item" ]] || fail "missing allowlist item: $item"
  rsync -a "$RELEASE_DIR/$item" "$TMP_DIR/"
done

mkdir -p "$TMP_DIR/data"
for filename in "${STATIC_DATA_FILES[@]}"; do
  [[ -e "$RELEASE_DIR/data/$filename" ]] || fail "missing static data file: data/$filename"
  rsync -a "$RELEASE_DIR/data/$filename" "$TMP_DIR/data/"
done

ZIP_PATH="$TMP_DIR/study_triage_v${VERSION}.ankiaddon"
(
  cd "$TMP_DIR"
  zip -rq "$ZIP_PATH" "${ALLOWLIST[@]}" data
)

ZIP_LIST="$(unzip -l "$ZIP_PATH")"
printf "%s\n" "$ZIP_LIST" | grep -q 'study_triage/' || fail "archive missing runtime tree"
printf "%s\n" "$ZIP_LIST" | grep -q 'study_triage_UI/study_triage/' && fail "archive contains duplicate runtime tree"
printf "%s\n" "$ZIP_LIST" | grep -qi 'quiz' && fail "archive contains quiz artifact"
printf "%s\n" "$ZIP_LIST" | grep -q 'meta.json' && fail "archive must not include meta.json"

for runtime_file in \
  'data/study_triage.log' \
  'data/missed_checkpoint.json' \
  'data/ui_state.json' \
  'data/review_mode_session.json' \
  'data/study_log.json'
do
  if printf "%s\n" "$ZIP_LIST" | grep -q "$runtime_file"; then
    fail "archive contains runtime file: $runtime_file"
  fi
done

echo "[release_gate] package validation OK"
echo "[release_gate] PASS"
