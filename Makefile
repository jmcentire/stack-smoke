.PHONY: check check-live stack-versions continuous

check:
	@./scripts/check-prereqs.sh

check-live:
	@./scripts/check-live-reeve.sh

stack-versions:
	@./scripts/check-stack-versions.sh

continuous:
	@./scripts/continuous-smoke.sh
