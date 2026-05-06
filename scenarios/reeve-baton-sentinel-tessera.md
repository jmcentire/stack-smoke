# Scenario: Reeve to Baton to Sentinel to Tessera

Status: proactive integration target. The harness should grow one assertion at
a time as each tool exposes a stable operational contract. Do not wait for a
production incident to justify these guardrails.

## Synthetic Input

- Tenant: smoke-test tenant
- Channel: email
- Message: benign booking request with Ledger canary fields available for
  taint scanning.

## Assertions

- Reeve accepts the inbound message and emits a Baton event.
- Baton receives the event on the adapter control event channel.
- Baton applies `configs/reeve-egress.yaml` field masks and canary fields.
- Sentinel records PACT-key attribution for the action.
- Tessera records the audit event and preserves hash-chain continuity.
- Reeve records slice-0.5 component health observations.

## Required Guardrail Loops

- **Aegis:** every hot-path external call in the flow has a declared budget.
- **Covenant:** every cross-boundary payload validates before and after egress.
- **Ledger:** sensitive fields in the synthetic message map to registry
  classifications and Baton egress masking.
- **Arbiter:** observed access produces a trust/blast-radius finding, even if
  the finding is "no violation".
- **Chronicler:** the request, decisions, and emitted events assemble into a
  bounded story.
- **Vigil:** the trace/event sample is eligible for anomaly baseline ingestion.
- **Stigmergy:** completed stories can be emitted as organizational/workflow
  signals when a consumer is configured.
- **Apprentice:** repeatable AI task outputs are eligible for quality-gated
  distillation metrics.
- **Signet:** sensitive credentials/proofs are scoped rather than read as raw
  process-wide secrets.
- **Witness:** human-review decisions use the shared decision primitive and
  preserve rationale.
- **Scram:** emergency predicates can observe the relevant failure signals.
- **Stack mode:** continuous smoke can distinguish live, ready, safe, and
  degraded states.
