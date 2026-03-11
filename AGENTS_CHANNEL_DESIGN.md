# Agents Channel Design: Visible Abby ↔ George Collaboration in Discord

## Status
Draft design (no implementation in this document).

## Objective
Create one shared Discord channel, `#agents`, where:

- Ken can address Abby and George using mentions (`@Abby`, `@George`)
- Abby and George can address Ken using `@Ken`
- Abby and George can collaborate with each other in-channel only
- All cross-agent coordination is visible to Ken (no hidden inter-agent messaging)
- Agent-to-agent reply chains are limited to a configurable max turn count (initially `5`)

## Core Principles

1. **Channel transparency first**: all agent-to-agent work must happen in `#agents`.
2. **Mention-gated activation**: agents only respond when explicitly mentioned or directly handed off.
3. **Deterministic coordination**: when both agents are mentioned, Abby responds first as coordinator.
4. **Bounded loops**: inter-agent reply chains stop at `maxTurns`.
5. **Policy over prompt**: enforce behavior with tool/policy restrictions, not instructions alone.

## Functional Requirements

### 1) Single shared channel
- Use one Discord channel named `#agents`.
- Both bot identities are present in the same channel.

### 2) Mention routing
- `@Abby` routes to Abby.
- `@George` routes to George.
- `@Ken` is allowed in both agent outputs for escalation/clarification.

### 3) Multi-mention behavior
- If message contains both `@Abby` and `@George`, Abby handles first response.
- Abby can hand off to George by mentioning `@George` with context.

### 4) Agent-to-agent thread budget
- Define `bridge.maxTurns` (default `5`).
- Count only agent-originated back-and-forth turns.
- On reaching cap, agent must stop and request Ken input.
- Budget value must be configurable later without code redesign.

### 5) Visible-only collaboration rule
- Abby and George are forbidden from hidden coordination paths for this workflow.
- No out-of-band agent messaging for task handoff when `#agents` is available.
- All meaningful handoff context must be posted in-channel.

## Non-Functional Requirements

- **Auditability**: Ken can reconstruct decision flow by reading channel history.
- **Safety**: no runaway looping between bots.
- **Predictability**: stable response order and stop conditions.
- **Extensibility**: future adjustable turn cap and optional per-task overrides.

## Proposed Architecture

### A. Channel and account layout
- Discord channel: `#agents`.
- Bot identity A: Abby account.
- Bot identity B: George account.
- Both accounts have permissions scoped to required channels only.

### B. Dispatch model
- Mention parser determines intended responder(s).
- Router applies deterministic rule set:
  - only `@Abby` -> Abby responds
  - only `@George` -> George responds
  - both mentioned -> Abby responds first

### C. Collaboration model
- Handoff format (human-readable):
  - `@George handoff: <context + requested action>`
  - `@Abby handoff: <summary + recommendation>`
- Each handoff increments turn counter.
- When counter reaches `bridge.maxTurns`, active agent posts stop notice and tags `@Ken`.

### D. Enforcement model (critical)
- Disable hidden cross-agent session messaging tools for Abby and George in this mode.
- Keep permitted messaging channel-bound to Discord `#agents` for inter-agent collaboration.
- Add explicit policy check: reject out-of-band handoff attempts.

## Message Lifecycle (example)

1. Ken posts: `@Abby investigate checkout issue and pull in @George if needed`.
2. Abby acknowledges, scopes task, and if needed posts `@George handoff: ...`.
3. George replies with findings, mentions `@Abby` for synthesis.
4. Abby returns plan and mentions `@Ken` for decision.
5. If exchanges reach cap, next agent message is stop + `@Ken`.

## What Ken Will See

- Two distinct bot identities in one channel (`Abby`, `George`).
- Explicit mentions showing who is being addressed next.
- Full visible trace of context transfer and decisions.
- Automatic pause after max inter-agent turns until Ken re-prompts.

## Configuration Surface (proposed)

```yaml
agentsBridge:
  enabled: true
  channelId: <#agents channel id>
  maxTurns: 5
  dualMentionLeader: abby
  visibleOnly: true
  allowHiddenInterAgentMessaging: false
```

## Guardrails and Failure Handling

- If mention target is ambiguous, ask Ken to clarify.
- If one bot is unavailable, responding bot reports degraded mode and tags `@Ken`.
- If turn counter storage fails, default to safe stop and escalate to Ken.
- If channel permissions drift, post configuration error and halt inter-agent loop.

## Rollout Plan

1. Create/confirm `#agents` channel and permissions.
2. Enable both bot accounts in that channel.
3. Apply mention-routing and deterministic dual-mention rule.
4. Enforce `visibleOnly` and disable hidden inter-agent tools.
5. Set `maxTurns=5`.
6. Run validation scenarios:
   - Abby-only mention
   - George-only mention
   - dual mention
   - handoff loop to cap
   - escalation to `@Ken`

## Acceptance Criteria

- Ken can trigger Abby and George by mention in one channel.
- Abby and George can mention each other and Ken.
- Inter-agent exchanges stop at configured cap.
- No hidden cross-agent messaging path is available for this workflow.
- Full collaboration context remains visible in `#agents`.
