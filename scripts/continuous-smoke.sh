#!/usr/bin/env bash
set -euo pipefail

interval="${SMOKE_INTERVAL_SECONDS:-60}"

while true; do
  started_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "stack-smoke cycle started: $started_at"
  ./scripts/check-prereqs.sh
  ./scripts/check-live-reeve.sh
  echo "stack-smoke cycle passed: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  sleep "$interval"
done
