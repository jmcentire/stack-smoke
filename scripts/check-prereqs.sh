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
require_path "$root/aegis"
require_path "$root/covenant"
require_path "$root/vigil"
require_path "$root/scram"
require_path "$root/witness"
require_path "$root/baton"
require_path "$root/sentinel"
require_path "$root/tessera"
require_path "$root/ledger"
require_path "$root/arbiter"
require_path "$root/chronicler"
require_path "$root/stigmergy"
require_path "$root/apprentice"
require_path "$root/signet"
require_path "$root/cartographer"
require_path "$root/constrain"
require_path "$root/pact"
require_path "$root/reeve/ledger-schemas/reeve.yaml"
require_path "$root/ledger/.ledger/registry/reeve_main.yaml"
require_path "$root/baton/baton.yaml"
require_path "$root/baton/configs/reeve-egress.yaml"
require_path "$root/exemplar-stack/docs/code-inventory.md"
require_path "$root/exemplar-stack/docs/infrastructure-handoff.md"

# Cartographer should have at least attempted to make Reeve legible to
# the broader stack. These drafts are inputs to declarative closeout, not
# proof that runtime enforcement is finished.
require_path "$root/reeve/.cartographer/drafts/baton/baton_draft.yaml"
require_path "$root/reeve/.cartographer/drafts/sentinel/manifest_draft.json"
require_path "$root/reeve/.cartographer/drafts/constrain/component_map_draft.yaml"

if [[ "$missing" != "0" ]]; then
  echo "stack-smoke prerequisites are incomplete" >&2
  exit 1
fi

echo "stack-smoke prerequisites are present"
