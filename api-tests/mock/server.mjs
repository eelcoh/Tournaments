// Stateful HTTP mock of the Tournaments backend.
// Covers every endpoint the Elm client calls. Accepts any non-empty username/password,
// issues a fixed Bearer token, and validates it for protected routes.

import { createServer } from "node:http";
import { randomUUID } from "node:crypto";

const PORT = Number(process.env.MOCK_PORT ?? 8787);
const TOKEN = "mock-token-abc123";

const state = {
  bets: new Map(), // uuid -> bet
  betsFlat: new Map(), // uuid -> bet with flat bracket
  activities: [],
  matchResults: { results: [] },
  topscorerResults: { topscorers: [] },
  knockoutsResults: { teams: {} },
  ranking: { summary: [], time: Math.floor(Date.now() / 1000) },
  rankingDetails: new Map(), // uuid -> details
};

function send(res, status, body, extraHeaders = {}) {
  const json = body === undefined ? "" : JSON.stringify(body);
  res.writeHead(status, {
    "Content-Type": "application/json",
    "Content-Length": Buffer.byteLength(json),
    ...extraHeaders,
  });
  res.end(json);
}

function readBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on("data", (c) => chunks.push(c));
    req.on("end", () => {
      const raw = Buffer.concat(chunks).toString("utf8");
      if (!raw) return resolve(null);
      try {
        resolve(JSON.parse(raw));
      } catch (e) {
        reject(e);
      }
    });
    req.on("error", reject);
  });
}

function requireAuth(req, res) {
  const auth = req.headers["authorization"];
  if (auth !== `Bearer ${TOKEN}`) {
    send(res, 401, { error: "unauthorized" });
    return false;
  }
  return true;
}

function makeBetSummary(bet) {
  return {
    name:
      bet.participant?.name ??
      bet.bet?.participant?.name ??
      "onbekend",
    active: bet.active ?? bet.bet?.active ?? true,
    uuid: bet.uuid ?? bet.bet?.uuid ?? null,
  };
}

function wrapBet(bet) {
  return { bet };
}

function unwrapBet(body) {
  return body?.bet ?? body;
}

const server = createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  const { method } = req;
  const path = url.pathname;

  let body = null;
  if (method === "POST" || method === "PUT") {
    try {
      body = await readBody(req);
    } catch {
      return send(res, 400, { error: "invalid json" });
    }
  }

  // Authentication
  if (method === "POST" && path === "/authentication/authentications") {
    if (!body?.username || !body?.password) {
      return send(res, 400, { error: "missing credentials" });
    }
    return send(res, 200, { token: TOKEN });
  }

  // Activities
  if (method === "GET" && path === "/activities") {
    return send(res, 200, { activities: state.activities });
  }
  if (method === "POST" && path === "/activities/comments") {
    const c = body?.comment ?? {};
    const activity = {
      type: "comment",
      meta: {
        date: Date.now(),
        active: true,
        uuid: randomUUID(),
      },
      author: c.author ?? "",
      msg: c.msg ?? [""],
    };
    state.activities.unshift(activity);
    return send(res, 200, { activities: state.activities });
  }
  if (method === "POST" && path === "/activities/blogs") {
    if (!requireAuth(req, res)) return;
    const b = body?.blog ?? {};
    const activity = {
      type: "blog",
      meta: {
        date: Date.now(),
        active: true,
        uuid: randomUUID(),
      },
      author: b.author ?? "",
      title: b.title ?? "",
      msg: b.msg ?? [""],
    };
    state.activities.unshift(activity);
    return send(res, 200, { activities: state.activities });
  }

  // Bets (user flow)
  if (method === "POST" && path === "/bets/") {
    const inner = unwrapBet(body) ?? {};
    const uuid = randomUUID();
    const saved = { ...inner, uuid, active: inner.active ?? true };
    state.bets.set(uuid, saved);
    return send(res, 200, wrapBet(saved));
  }
  const betIdMatch = path.match(/^\/bets\/([^/]+)$/);
  if (betIdMatch) {
    const uuid = betIdMatch[1];
    if (method === "GET") {
      const found = state.bets.get(uuid);
      if (!found) return send(res, 404, { error: "not found" });
      return send(res, 200, wrapBet(found));
    }
    if (method === "PUT") {
      const inner = unwrapBet(body) ?? {};
      const saved = { ...inner, uuid };
      state.bets.set(uuid, saved);
      return send(res, 200, wrapBet(saved));
    }
  }

  // Bets (flat wire format) — separate storage so the echoed bracket
  // stays in the same flat shape the Elm client sent.
  if (method === "POST" && path === "/bets/flat/") {
    const inner = unwrapBet(body) ?? {};
    const uuid = randomUUID();
    const saved = { ...inner, uuid, active: inner.active ?? true };
    state.betsFlat.set(uuid, saved);
    return send(res, 200, wrapBet(saved));
  }
  const betFlatIdMatch = path.match(/^\/bets\/flat\/([^/]+)$/);
  if (betFlatIdMatch) {
    const uuid = betFlatIdMatch[1];
    if (method === "GET") {
      const found = state.betsFlat.get(uuid);
      if (!found) return send(res, 404, { error: "not found" });
      return send(res, 200, wrapBet(found));
    }
    if (method === "PUT") {
      const inner = unwrapBet(body) ?? {};
      const saved = { ...inner, uuid };
      state.betsFlat.set(uuid, saved);
      return send(res, 200, wrapBet(saved));
    }
  }

  // Bets list + admin toggles
  if (method === "GET" && path === "/bets/") {
    const list = [...state.bets.values()].map(makeBetSummary);
    return send(res, 200, list);
  }
  const activateMatch = path.match(/^\/bets\/(activate|deactivate)\/([^/]+)$/);
  if (method === "POST" && activateMatch) {
    if (!requireAuth(req, res)) return;
    const [, action, uuid] = activateMatch;
    // Toggle whichever store holds this uuid. Flat-created bets land in
    // betsFlat; legacy nested-created bets land in bets.
    const store = state.betsFlat.has(uuid)
      ? state.betsFlat
      : state.bets.has(uuid)
        ? state.bets
        : null;
    if (!store) return send(res, 404, { error: "not found" });
    const bet = store.get(uuid);
    bet.active = action === "activate";
    store.set(uuid, bet);
    return send(res, 200, wrapBet(bet));
  }

  // Results: matches
  if (method === "GET" && path === "/bets/results/matches/") {
    return send(res, 200, state.matchResults);
  }
  if (method === "POST" && path === "/bets/results/matches/initial/") {
    if (!requireAuth(req, res)) return;
    state.matchResults = body ?? { results: [] };
    return send(res, 200, state.matchResults);
  }
  const matchResultMatch = path.match(/^\/bets\/results\/matches\/([^/]+)$/);
  if (method === "PUT" && matchResultMatch) {
    if (!requireAuth(req, res)) return;
    const matchId = matchResultMatch[1];
    const incoming = body ?? {};
    const existing = state.matchResults.results.find((r) => r.match === matchId);
    if (existing) Object.assign(existing, incoming);
    else state.matchResults.results.push(incoming);
    return send(res, 200, state.matchResults);
  }

  // Results: topscorer
  if (method === "GET" && path === "/bets/results/topscorer/") {
    return send(res, 200, state.topscorerResults);
  }
  if (method === "POST" && path === "/bets/results/topscorer/initial/") {
    if (!requireAuth(req, res)) return;
    state.topscorerResults = { topscorers: [] };
    return send(res, 200, state.topscorerResults);
  }
  if (method === "POST" && path === "/bets/results/topscorer/") {
    if (!requireAuth(req, res)) return;
    state.topscorerResults = body ?? { topscorers: [] };
    return send(res, 200, state.topscorerResults);
  }

  // Results: knockouts
  if (method === "GET" && path === "/bets/results/knockouts/") {
    return send(res, 200, state.knockoutsResults);
  }
  if (method === "POST" && path === "/bets/results/knockouts/initial/") {
    if (!requireAuth(req, res)) return;
    state.knockoutsResults = { teams: {} };
    return send(res, 200, state.knockoutsResults);
  }
  if (method === "POST" && path === "/bets/results/knockouts/") {
    if (!requireAuth(req, res)) return;
    state.knockoutsResults = body ?? { teams: {} };
    return send(res, 200, state.knockoutsResults);
  }

  // Ranking
  if (method === "GET" && path === "/bets/ranking/") {
    return send(res, 200, state.ranking);
  }
  const rankingDetailMatch = path.match(/^\/bets\/ranking\/([^/]+)$/);
  if (method === "GET" && rankingDetailMatch) {
    const uuid = rankingDetailMatch[1];
    const details = state.rankingDetails.get(uuid) ?? {
      name: "Mock Deelnemer",
      rounds: [],
      topscorer: 0,
      total: 0,
      uuid,
      bet: {
        answers: {
          matches: {},
          bracket: { bracket: { nodes: [] }, points: null },
          topscorer: { topscorer: { name: null, team: null }, points: null },
        },
        uuid,
        active: true,
        participant: {
          name: "Mock",
          address: "",
          residence: "",
          phone: "",
          email: "",
          howyouknowus: "",
        },
      },
    };
    return send(res, 200, details);
  }
  if (method === "POST" && path === "/bets/ranking/initial/") {
    if (!requireAuth(req, res)) return;
    state.ranking = {
      summary: [],
      time: Math.floor(Date.now() / 1000),
    };
    return send(res, 200, state.ranking);
  }

  send(res, 404, { error: `no mock route for ${method} ${path}` });
});

server.listen(PORT, () => {
  console.log(`[mock] listening on http://localhost:${PORT}`);
});

for (const sig of ["SIGINT", "SIGTERM"]) {
  process.on(sig, () => {
    console.log(`[mock] ${sig} received, shutting down`);
    server.close(() => process.exit(0));
  });
}
