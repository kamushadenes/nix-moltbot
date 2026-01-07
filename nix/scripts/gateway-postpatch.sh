#!/bin/sh
set -e
if [ -f package.json ]; then
  "$REMOVE_PACKAGE_MANAGER_FIELD_SH" package.json
fi

if [ -f src/logging.ts ]; then
  if ! grep -q "CLAWDBOT_LOG_DIR" src/logging.ts; then
    python3 - <<'PY'
from pathlib import Path

path = Path("src/logging.ts")
if path.exists():
    text = path.read_text()
    old = 'export const DEFAULT_LOG_DIR = "/tmp/clawdbot";'
    new = 'export const DEFAULT_LOG_DIR = process.env.CLAWDBOT_LOG_DIR ?? "/tmp/clawdbot";'
    if old in text:
        path.write_text(text.replace(old, new))
PY
  fi
fi
