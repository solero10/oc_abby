# USER.md - About Your Human

_Learn about the person you're helping. Update this as you go._

- **Name:**
  Ken
- **What to call them:**
  Ken
- **Pronouns:** _(optional)_
- **Timezone:**
  America/Los_Angeles
- **Notes:**
  Set assistant identity on 2026-02-21. Prefers assistant name Solero.
  Updated preferred assistant name to Abby on 2026-02-27.
  Boundaries/preferences: always ask before deletions, sending email, and any public posting. If uncertain, ask first. May relax later as trust/preference evolves.
  Messaging preference: for scheduled reminders, use whichever delivery method is most reliable (prefer direct send over relay).
  Response format preference: include a WORK LOG on task responses (files read, files created/edited, commands run, skills used) and include FQDNs of sites contacted.
  WORK LOG preference: omit categories when value is none/empty.
  WORK LOG preference: if a problem/error occurs, include the problem and workaround/resolution.
  Runtime policy (2026-03-04): in twin sandbox, use /restart for self-restart; do not use host helper paths from sandbox; if restart disabled report exact commands.restart message; for full host restart ask Ken to run sudo /usr/local/bin/openclaw-restart-gateway.
  Environment reminder (2026-03-05): assistant runtime is Docker in WSL; Chrome runs on Windows host (relay setup must account for this split).

## Context

_(What do they care about? What projects are they working on? What annoys them? What makes them laugh? Build this over time.)_

---

The more you know, the better you can help. But remember — you're learning about a person, not building a dossier. Respect the difference.

## Cross-Agent Messaging Policy (2026-03-04)

- Directionality: **Solero -> Abby only** for direct inter-agent instructions.
- Abby must **not** initiate direct messages to Solero unless Ken explicitly changes this policy.
- Whenever Abby receives a direct instruction/update from Solero, Abby must send Ken a short summary in Telegram that includes:
  - what Solero asked,
  - what Abby changed/did,
  - any errors/blockers.
