#!/usr/bin/env bash
set -euo pipefail

baton_base_url="${BATON_SMOKE_BASE_URL:-https://baton-stack.fly.dev}"
expected_baton_version="${EXPECTED_BATON_VERSION:-0.3.5}"

tmp="$(mktemp)"
cleanup() {
  rm -f "$tmp"
}
trap cleanup EXIT

url="${baton_base_url}/v1/about"
code="$(curl -fsS -o "$tmp" -w '%{http_code}' "$url" || true)"
if [[ "$code" != "200" ]]; then
  echo "failed: baton about $url -> HTTP ${code:-curl-error}" >&2
  sed -n '1,20p' "$tmp" >&2 || true
  exit 1
fi

python3 - "$tmp" "$expected_baton_version" <<'PY'
import json
import sys

path, expected = sys.argv[1:3]
with open(path, "r", encoding="utf-8") as f:
    about = json.load(f)

component = about.get("component")
version = about.get("version")
if component != "baton":
    raise SystemExit(f"failed: expected component baton, got {component!r}")
if version != expected:
    raise SystemExit(f"failed: baton version drift: expected {expected}, got {version!r}")

print(f"ok: baton version {version}")
PY
