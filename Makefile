.PHONY: check check-live continuous

check:
	@./scripts/check-prereqs.sh

check-live:
	@./scripts/check-live-reeve.sh

continuous:
	@./scripts/continuous-smoke.sh
