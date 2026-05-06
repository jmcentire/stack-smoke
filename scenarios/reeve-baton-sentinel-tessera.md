# Scenario: Reeve to Baton to Sentinel to Tessera

Status: scaffolded, blocked on Wave 1 and 2 contracts.

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

