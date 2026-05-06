# Stack Smoke

Stack-wide smoke harness for Exemplar components. This repo owns assertions
that cross component boundaries; individual component repos keep their own
unit and integration tests.

## Current Scope

This repo is the continuous-smoke home for the Exemplar stack. It starts with
declaration/runtime-surface checks and live Reeve smoke endpoints, then grows
into the full cross-component exercise. Safety and observability integrations
are proactive guardrails here; they are not deferred until a user-visible
failure proves the need.

Current checks:

- Local checkout/artifact presence for the full Exemplar safety toolchain.
- Reeve live smoke endpoints when `REEVE_SMOKE_BASE_URL` is set.
- Scenario documentation for the target Reeve -> Baton -> Sentinel -> Tessera
  path plus the broader trust, story, anomaly, emergency, and authority loops.

## Target Flow

1. Drive a synthetic inbound message through Reeve.
2. Assert Reeve emits the Baton event.
3. Assert Baton scans Ledger-derived fields for taint fingerprints.
4. Assert Sentinel records PACT-key attribution.
5. Assert Tessera appends an audit event with an intact hash chain.
6. Assert Reeve slice-0.5 component observations land.

## Commands

```bash
make check       # local repo/artifact prerequisites
make check-live  # live Reeve smoke endpoints
make continuous  # repeat both checks; interval controlled by SMOKE_INTERVAL_SECONDS
```

`make check-live` defaults to `https://reeve-staging.fly.dev`. Override with
`REEVE_SMOKE_BASE_URL=https://reeve.fly.dev` for production or a local URL.

`make continuous` is intentionally simple: run it under a process supervisor,
cron, or CI schedule until the harness has its own scheduler.
