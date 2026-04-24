# API tests

HTTP contract tests for the Tournaments backend. Uses [Hurl](https://hurl.dev) as the test runner so the specs are plain `.hurl` files: readable, diffable, and runnable from CI.

The same tests run in two modes:

- **mock** (default) — a stateful Node mock server is started on `localhost:8787` and torn down at the end. Covers every endpoint the Elm client calls. Good for offline work and CI smoke tests.
- **live** — runs against a real backend whose URL and credentials you set in `.env`.

## Prerequisites

- Node 18+ (uses built-in `http`; no npm deps)
- Hurl 5+ (`pacman -S hurl` on Arch, `brew install hurl` on macOS, or see <https://hurl.dev/docs/installation.html>)
- GNU make

## Run against the mock

```
make test
```

The mock issues a fixed token, echoes bet UUIDs, validates `Authorization: Bearer` headers on protected routes, and 404s on unknown paths so missing endpoints fail loudly.

## Run against a real backend

```
cp .env.example .env
$EDITOR .env          # fill in BASE_URL, TEST_USER, TEST_PASS
make test-live
```

By default mutating admin endpoints (initial seeds, match writes, activate/deactivate) are **skipped** so the suite is safe to point at staging. To include them, set `RUN_MUTATING=1` in `.env`.

## Layout

```
api-tests/
  hurl/          numbered test files; run in order so token + bet_uuid propagate
  fixtures/      JSON request bodies referenced from hurl files
  mock/          Node mock server (single file, no deps)
  Makefile       `make test` / `make test-live` / `make mock` / `make clean`
  .env.example   copy to .env for live runs
```

## Endpoint coverage

| Group      | Method | Path                                       | File                             |
|------------|--------|--------------------------------------------|----------------------------------|
| Auth       | POST   | `/authentication/authentications`          | `01-auth.hurl`                   |
| Bets       | POST   | `/bets/`                                   | `02-bets.hurl`                   |
| Bets       | GET    | `/bets/{uuid}`                             | `02-bets.hurl`                   |
| Bets       | PUT    | `/bets/{uuid}`                             | `02-bets.hurl`                   |
| Activities | GET    | `/activities`                              | `03-activities.hurl`             |
| Activities | POST   | `/activities/comments`                     | `03-activities.hurl`             |
| Activities | POST   | `/activities/blogs` (auth)                 | `03-activities.hurl`             |
| Matches    | GET    | `/bets/results/matches/`                   | `04-results-matches.hurl`        |
| Matches    | PUT    | `/bets/results/matches/{id}` (auth)        | `04-results-matches.hurl`        |
| Matches    | POST   | `/bets/results/matches/initial/` (auth)    | `04-results-matches.hurl`        |
| Topscorer  | GET    | `/bets/results/topscorer/`                 | `05-results-topscorer.hurl`      |
| Topscorer  | POST   | `/bets/results/topscorer/` (auth)          | `05-results-topscorer.hurl`      |
| Topscorer  | POST   | `/bets/results/topscorer/initial/` (auth)  | `05-results-topscorer.hurl`      |
| Knockouts  | GET    | `/bets/results/knockouts/`                 | `06-results-knockouts.hurl`      |
| Knockouts  | POST   | `/bets/results/knockouts/` (auth)          | `06-results-knockouts.hurl`      |
| Knockouts  | POST   | `/bets/results/knockouts/initial/` (auth)  | `06-results-knockouts.hurl`      |
| Ranking    | GET    | `/bets/ranking/`                           | `07-results-ranking.hurl`        |
| Ranking    | GET    | `/bets/ranking/{uuid}`                     | `07-results-ranking.hurl`        |
| Ranking    | POST   | `/bets/ranking/initial/` (auth)            | `07-results-ranking.hurl`        |
| Admin      | GET    | `/bets/`                                   | `07-results-ranking.hurl`        |
| Admin      | POST   | `/bets/activate/{uuid}` (auth)             | `07-results-ranking.hurl`        |
| Admin      | POST   | `/bets/deactivate/{uuid}` (auth)           | `07-results-ranking.hurl`        |

Every protected endpoint also has a negative test that asserts an unauthenticated request is rejected.

## Notes

- Hurl runs the files in lexical order; `01-auth.hurl` captures `{{token}}` and later files reuse it, and `02-bets.hurl` captures `{{bet_uuid}}` for `07-results-ranking.hurl`.
- The mock's state is per-process — it resets on every `make test` run.
- Against a live backend, `bet_uuid` comes from whatever the server returned, so ranking detail lookup hits a real, just-created bet.
- To add an endpoint: drop a new `NN-name.hurl` into `hurl/` and (if the backend is stateful) extend `mock/server.mjs`.
