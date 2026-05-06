#!/usr/bin/env bash
set -euo pipefail

reeve_base_url="${REEVE_SMOKE_BASE_URL:-https://reeve-staging.fly.dev}"
baton_base_url="${BATON_SMOKE_BASE_URL:-https://baton-stack.fly.dev}"

check_endpoint() {
  local base_url="$1"
  local path="$2"
  local label="$3"
  local needle="${4:-}"
  local url="${base_url}${path}"
  local tmp
  tmp="$(mktemp)"
  local code
  code="$(curl -fsS -o "$tmp" -w '%{http_code}' "$url" || true)"
  if [[ "$code" != "200" ]]; then
    echo "failed: $label $url -> HTTP ${code:-curl-error}" >&2
    sed -n '1,20p' "$tmp" >&2 || true
    rm -f "$tmp"
    return 1
  fi
  if [[ -n "$needle" ]] && ! grep -q "$needle" "$tmp"; then
    echo "failed: $label $url missing expected content: $needle" >&2
    sed -n '1,20p' "$tmp" >&2 || true
    rm -f "$tmp"
    return 1
  fi
  echo "ok: $label $url"
  rm -f "$tmp"
}

check_reeve_endpoint() {
  local path="$1"
  check_endpoint "$reeve_base_url" "$path" "reeve"
}

check_reeve_endpoint /health/live
check_reeve_endpoint /health/ready
check_reeve_endpoint /smoke/audit-chain-intact
check_reeve_endpoint /smoke/stack-mode-nominal
check_reeve_endpoint /smoke/registries-populated
check_reeve_endpoint /smoke/manifest-quarantine-bounded
check_reeve_endpoint /smoke/contract-violations-bounded

check_endpoint "$baton_base_url" /api/snapshot "baton" "reeve-prod"
