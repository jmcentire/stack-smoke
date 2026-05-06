#!/usr/bin/env bash
set -euo pipefail

root="${STACK_ROOT:-/Users/jmcentire/Code}"
missing=0

require_path() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    echo "missing: $path" >&2
    missing=1
  else
    echo "ok: $path"
  fi
}

require_path "$root/reeve"
require_path "$root/baton"
require_path "$root/sentinel"
require_path "$root/tessera"
require_path "$root/ledger"
require_path "$root/reeve/ledger-schemas/reeve.yaml"
require_path "$root/ledger/.ledger/registry/reeve_main.yaml"
require_path "$root/baton/baton.yaml"
require_path "$root/baton/configs/reeve-egress.yaml"

if [[ "$missing" != "0" ]]; then
  echo "stack-smoke prerequisites are incomplete" >&2
  exit 1
fi

echo "stack-smoke prerequisites are present"

