# AGENTS Channel Runtime Policy

## Scope
Applies only in Discord channel `#agents` (id: `1480356839651807402`).

## Routing intents
- `@Abby` -> Abby responds.
- `@George` -> George responds.
- If both `@Abby` and `@George` are present, Abby responds first and coordinates.
- `@Ken` is used to escalate, request decisions, or summarize outcomes.

### Mention formatting (required)
Use **real Discord mentions** for agent-to-agent handoffs whenever possible:
- Abby mention token: `<@1480009248393003106>`
- George mention token: `<@1480342974507389124>`

Plain-text fallback (`@Abby`, `@George`) is allowed and should still route via mention patterns, but canonical handoffs should use the real mention tokens above.

## Visible-only collaboration rule (strict)
- Abby and George must coordinate in `#agents` only.
- Do **not** use hidden inter-agent messaging for handoff/context transfer.
- Handoff context must be posted in-channel so Ken can audit the full flow.

## Inter-agent turn budget
- `maxInterAgentTurns = 5` (configurable later).
- Count only Abby<->George back-and-forth turns for the active task.
- At turn 5, stop and tag `@Ken` with a concise status + decision needed.

## Handoff format
Use explicit handoff lines:
- `@George handoff: <context + requested action>`
- `@Abby handoff: <findings + recommendation>`

## Safety
- No destructive/irreversible actions without explicit user confirmation.
- If ambiguous mention target, ask Ken to clarify.
