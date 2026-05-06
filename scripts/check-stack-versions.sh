#!/usr/bin/env bash
set -euo pipefail

reeve_staging_base_url="${REEVE_STAGING_SMOKE_BASE_URL:-https://reeve-staging.fly.dev}"
reeve_prod_base_url="${REEVE_PROD_SMOKE_BASE_URL:-https://reeve.fly.dev}"
baton_base_url="${BATON_SMOKE_BASE_URL:-https://baton-stack.fly.dev}"
expected_reeve_version="${EXPECTED_REEVE_VERSION:-0.5.6}"
expected_baton_version="${EXPECTED_BATON_VERSION:-0.3.5}"

tmp_files=()
cleanup() {
  rm -f "${tmp_files[@]}"
}
trap cleanup EXIT

check_about() {
  local label="$1"
  local base_url="$2"
  local expected_component="$3"
  local expected_version="$4"
  local tmp
  tmp="$(mktemp)"
  tmp_files+=("$tmp")

  local url="${base_url}/v1/about"
  local code
  code="$(curl -fsS -o "$tmp" -w '%{http_code}' "$url" || true)"
  if [[ "$code" != "200" ]]; then
    echo "failed: ${label} about $url -> HTTP ${code:-curl-error}" >&2
    sed -n '1,20p' "$tmp" >&2 || true
    return 1
  fi

  python3 - "$tmp" "$expected_component" "$expected_version" "$label" <<'PY'
import json
import sys

path, expected_component, expected_version, label = sys.argv[1:5]
with open(path, "r", encoding="utf-8") as f:
    about = json.load(f)

component = about.get("component")
version = about.get("version")
if component != expected_component:
    raise SystemExit(f"failed: {label} expected component {expected_component!r}, got {component!r}")
if version != expected_version:
    raise SystemExit(
        f"failed: {label} version drift: expected {expected_version}, got {version!r}"
    )

print(f"ok: {label} {component} version {version}")
PY
}

check_about "reeve-staging" "$reeve_staging_base_url" "reeve" "$expected_reeve_version"
check_about "reeve-prod" "$reeve_prod_base_url" "reeve" "$expected_reeve_version"
check_about "baton" "$baton_base_url" "baton" "$expected_baton_version"
