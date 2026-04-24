# API test suite runner.
#
# Targets:
#   make test        -- start local mock, run all hurl tests against it, stop mock
#   make test-live   -- run hurl tests against $BASE_URL from .env (real backend)
#   make mock        -- run just the mock server in foreground (for debugging)

SHELL := /bin/bash

HURL_FILES := $(sort $(wildcard hurl/*.hurl))
VARS_FILE  := vars.generated.env
MOCK_PORT  ?= 8787
MOCK_PID   := .mock.pid

.PHONY: test test-live mock stop-mock clean _vars-mock _vars-live _run

test: stop-mock _vars-mock
	@node mock/server.mjs & echo $$! > $(MOCK_PID)
	@sleep 0.3
	@$(MAKE) --no-print-directory _run; rc=$$?; \
	  $(MAKE) --no-print-directory stop-mock; \
	  exit $$rc

test-live: _vars-live _run

mock:
	@node mock/server.mjs

stop-mock:
	@if [ -f $(MOCK_PID) ]; then \
	  kill $$(cat $(MOCK_PID)) 2>/dev/null || true; \
	  rm -f $(MOCK_PID); \
	fi

clean: stop-mock
	@rm -f $(VARS_FILE)

_vars-mock:
	@printf 'base_url=http://localhost:%s\ntest_user=mock\ntest_pass=mock\nskip_mutating=false\n' \
	  "$(MOCK_PORT)" > $(VARS_FILE)

_vars-live:
	@if [ ! -f .env ]; then echo "error: .env not found (copy .env.example first)"; exit 2; fi
	@set -a; . ./.env; set +a; \
	  if [ -z "$$BASE_URL" ] || [ -z "$$TEST_USER" ] || [ -z "$$TEST_PASS" ]; then \
	    echo "error: BASE_URL / TEST_USER / TEST_PASS must be set in .env"; exit 2; \
	  fi; \
	  skip="true"; if [ "$$RUN_MUTATING" = "1" ]; then skip="false"; fi; \
	  printf 'base_url=%s\ntest_user=%s\ntest_pass=%s\nskip_mutating=%s\n' \
	    "$$BASE_URL" "$$TEST_USER" "$$TEST_PASS" "$$skip" > $(VARS_FILE)

_run:
	@command -v hurl >/dev/null || { echo "error: hurl not installed (see api-tests/README.md)"; exit 127; }
	hurl --test --file-root . --variables-file $(VARS_FILE) $(HURL_FILES)
