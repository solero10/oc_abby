# MEMORY.md

## Current Agent Inventory
- Abby (`main`)
  - Role: Chief of Staff / primary front door
  - Status: active
  - Responsibilities: intake, coordination, planning, governance-aware routing
  - Constraints: should not casually recommend new permanent agents without evaluation; use Leslie for boundary/new-agent decisions
- Leslie (`leslie`)
  - Role: governance and architecture reviewer
  - Status: active (v1)
  - Responsibilities: architecture review, requirement analysis, recommendation artifacts, ecosystem boundary checks
  - Constraints: advisory-only; no direct apply/provisioning; sandbox `all`, workspace access `ro`, minimal read-mostly tools
- George (`george`)
  - Role: browser troubleshooting specialist (human-in-the-loop)
  - Status: active (v1)
  - Responsibilities: open/drive built-in browser for diagnostics, inspect website state/errors, guide reproducible troubleshooting steps in Discord
  - Constraints: should not handle credentials/MFA/captcha; should require explicit confirmation before destructive website actions

## Future Roadmap Register
- Create a separate apply/provisioning agent later (explicitly separate from Leslie).
- Keep specialist architecture narrow and deliberate (avoid sprawl), with monthly governance review cadence.
- Continue tightening Discord trust boundaries (group policy/allowlists/tool exposure), now that a dedicated Discord browser-troubleshooting agent (`george`) exists for channel-specific routing.

## Governance Rules
- Abby is the default front door for new and multi-agent work.
- Abby should consult Leslie for agent-boundary and new-agent decisions.
- Recommendations must separate **Observed Facts** from **Inferences**.
- Before any new-agent recommendation, run explicit gate:
  1) handled by main for now
  2) temporary sub-agent
  3) revised existing agent
  4) new permanent agent
- For OpenClaw state/config answers, CLI output is ground truth.
- For assistant-initiated restart/reload actions:
  - send 5-second pre-notice
  - write/update restart continuity checkpoint in `state/restart-sentinel.json` and `state/inflight-task.json`
  - first post-restart message must be exactly "I am back up"
  - then verify and report whether the last in-flight step fully completed
  - send one explicit closure summary before changing topics (completed, verification, pending/none, next-step owner)
  - clear sentinel only after verification is reported
- Discord `#agents` (id `1480356839651807402`) is the visible collaboration surface for Abby↔George handoffs.
- Hidden inter-agent coordination is disallowed for Abby↔George workflow; handoffs must be posted in-channel.
- Inter-agent turn budget in `#agents` defaults to 5 turns, then escalate to Ken.

## Open Architecture Questions
- Why does cross-provider send remain denied in some long-lived Telegram-bound sessions even after valid `tools.message.crossContext.allowAcrossProviders=true` at root config?
- `daily-health-check-report` cron job still targets `agent=twin` even after twin removal; should be reassigned/cleaned.
- Should Discord remain on `main` with allowlist only, or move to a dedicated restricted agent for stronger trust boundaries?
- Fix `gateway.nodes.denyCommands` ineffective entries (unknown command names) to remove persistent audit warning.
- Ensure all operational scripts/hooks remain home-relative after migration to native WSL (`/home/kernk`) to prevent regressions to legacy `/home/node` paths.

## Active Proposals
- Leslie: implemented as v1 governance/advisory agent (active).
- Provisioning/Apply Agent: deferred (planned for later explicit design/approval).
