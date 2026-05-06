# Stack Smoke

Stack-wide smoke harness for Exemplar components. This repo owns assertions
that cross component boundaries; individual component repos keep their own
unit and integration tests.

## Current Scope

Wave 1 and 2 component boundaries are still landing, so this scaffold does
not pretend to run the full Reeve -> Baton -> Sentinel -> Tessera path yet.
It verifies local prerequisites and records the target flow.

## Target Flow

1. Drive a synthetic inbound message through Reeve.
2. Assert Reeve emits the Baton event.
3. Assert Baton scans Ledger-derived fields for taint fingerprints.
4. Assert Sentinel records PACT-key attribution.
5. Assert Tessera appends an audit event with an intact hash chain.
6. Assert Reeve slice-0.5 component observations land.

## Commands

```bash
make check
```

`make check` verifies the participating local repos and generated operational
artifacts exist. Full end-to-end execution lands after aegis/covenant/vigil
ADRs and Track 2 witness/scram contracts stabilize.

