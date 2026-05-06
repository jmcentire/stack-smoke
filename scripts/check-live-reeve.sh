#!/usr/bin/env bash
set -euo pipefail

base_url="${REEVE_SMOKE_BASE_URL:-https://reeve-staging.fly.dev}"

check_endpoint() {
  local path="$1"
  local url="${base_url}${path}"
  local tmp
  tmp="$(mktemp)"
  local code
  code="$(curl -fsS -o "$tmp" -w '%{http_code}' "$url" || true)"
  if [[ "$code" != "200" ]]; then
    echo "failed: $url -> HTTP ${code:-curl-error}" >&2
    sed -n '1,20p' "$tmp" >&2 || true
    rm -f "$tmp"
    return 1
  fi
  echo "ok: $url"
  rm -f "$tmp"
}

check_endpoint /health/live
check_endpoint /health/ready
check_endpoint /smoke/audit-chain-intact
check_endpoint /smoke/stack-mode-nominal
check_endpoint /smoke/registries-populated
check_endpoint /smoke/manifest-quarantine-bounded
check_endpoint /smoke/contract-violations-bounded
