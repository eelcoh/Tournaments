# External Integrations

**Analysis Date:** 2026-02-23

## APIs & External Services

**Backend API:**
- **Service:** Custom REST API (no specific platform detected)
- **Purpose:** Bet submission/retrieval, match results, rankings, activities
- **SDK/Client:** ohanhi/remotedata-http 4.0.0
- **Auth:** Bearer token (Authorization header)

**API Endpoints Used:**

*Bets:*
- `GET /bets/` - Fetch all bets for current user
- `GET /bets/{uuid}` - Fetch single bet by ID
- `POST /bets/` - Create new bet
- `PUT /bets/{uuid}` - Update existing bet
- `POST /bets/activate/{uuid}` - Activate bet
- `POST /bets/deactivate/{uuid}` - Deactivate bet

*Ranking:*
- `GET /bets/ranking/` - Fetch all bets ranking
- `GET /bets/ranking/{uuid}` - Fetch specific user's ranking details
- `POST /bets/ranking/initial/` - Initialize/recreate ranking (admin)

*Match Results:*
- `GET /bets/results/matches/` - Fetch all match results
- `PUT /bets/results/matches/{matchId}` - Update match result score

*Knockout Results:*
- `GET /bets/results/knockouts/` - Fetch knockout bracket results
- `POST /bets/results/knockouts/initial/` - Initialize knockout results (admin)
- `PUT /bets/results/knockouts/` - Update knockout results

*Activities (Comments & Blog Posts):*
- `GET /activities` - Fetch activity feed (comments and blog posts)
- `POST /activities/comments` - Submit comment (public)
- `POST /activities/blogs` - Submit blog post (authenticated)

*Authentication:*
- `POST /authentication/authentications` - Login with username/password

## Data Storage

**Databases:**
- **Type/Provider:** Not detected from frontend (backend only)
- **Client:** REST API communication via HTTP
- **Data Persistence:** All data stored on backend; no client-side database

**Client-Side Storage:**
- No localStorage, sessionStorage, or IndexedDB usage detected
- Application state maintained in Elm model during session
- Data survives page refresh via server fetch on app load

## File Storage

- **Backend:** Not detected (no file upload endpoints)
- **Frontend:** No file operations detected

## Caching

- **Service:** None
- **Strategy:** RemoteData.Http handles request caching via DataStatus wrapper (Fresh/Filthy/Stale)

## Authentication & Identity

**Auth Provider:**
- Custom username/password authentication
- **Implementation:**
  - POST to `/authentication/authentications` with encoded credentials
  - Returns Bearer token (opaque string)
  - Token stored in Elm model as `Token` type
  - Token passed in `Authorization: Bearer {token}` header for authenticated requests

**Credential Handling:**
- `src/Authentication.elm` - Login form and token management
- Form fields: username, password
- Token lifecycle: Login → Store in Model.token → Use in headers → Clear on logout

## Monitoring & Observability

**Error Tracking:**
- Not detected

**Logs:**
- **Approach:** No backend logging integration
- Debug output only via Elm console (not suitable for production use with `--optimize`)

## CI/CD & Deployment

**Hosting:**
- Static file hosting (HTTP server)
- Served from `build/` directory
- No application server required

**CI Pipeline:**
- Not detected in codebase
- Build via Makefile manually

## Environment Configuration

**Required Environment Variables:**
- None detected (API URL hardcoded as relative `/` base)

**Secrets Management:**
- Credentials entered via login form (not stored in config files)
- Bearer token handled in memory (not persisted to disk)

**API Base URL:**
- Hardcoded as relative paths (e.g., `/bets/`, `/authentication/authentications`)
- Assumes backend served from same origin or accessible via CORS

## Webhooks & Callbacks

**Incoming:**
- None detected

**Outgoing:**
- None detected

## External Data Sources

**Fonts:**
- Google Fonts: Sometype Mono
  - CDN: `https://fonts.googleapis.com/css2?family=Sometype+Mono:ital,wght@0,400..700;1,400..700&display=swap`
  - Preconnect: `https://fonts.googleapis.com`, `https://fonts.gstatic.com`

## HTTP Communication Patterns

**RemoteData.Http Usage:**
- All HTTP requests wrapped in RemoteData for state management
- Import pattern: `import RemoteData.Http as Http` or `as Web`
- Common functions:
  - `Http.get url msg decoder` - GET request
  - `Http.post url msg decoder body` - POST request
  - `Http.put url msg decoder body` - PUT request
  - `Http.postWithConfig config url msg decoder body` - POST with custom config (headers)

**Authentication Flow:**
- Requests without auth: `Web.get` / `Web.post` (public endpoints)
- Requests with auth: Use `defaultConfig | headers = [ Http.header "Authorization" bearer ]` via `Web.postWithConfig` / `Web.putWithConfig`

**Error Handling:**
- HTTP failures captured in RemoteData.Failure
- No retry logic detected
- Failures displayed to user via UI error messages

## API Contract

**Request Format:**
- JSON bodies via `Json.Encode`
- Content-Type: application/json (handled by remotedata-http)

**Response Format:**
- JSON responses decoded via custom Decoder functions
- Located in respective modules: `API.Bets`, `Results.Bets`, `Results.Matches`, etc.
- Date fields: Unix milliseconds (Posix time)

**Key Decoders:**
- `Bets.Bet.decode` - Full bet submission with answers
- `Bets.Bet.decodeBet` - Simpler bet structure (used for API responses)
- Custom decoders for Results, Rankings, Activities with JSON pipeline pattern

---

*Integration audit: 2026-02-23*
