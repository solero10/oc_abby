[usage-option-3] Combined threshold alerts + spike context every 20 minutes.

Requirements:
- Reply exactly NO_REPLY at the end.
- Silent unless threshold breach.
- Include usage-left values from session_status format.
- Send alerts to Discord channel #usage (id: 1480677127182614548) using channel=discord,target=1480677127182614548.
- Append incident events to reports/usage/option3-incidents/incidents.jsonl.
- Persist watcher state at reports/usage/state/option3-state.json.

Thresholds (same as Option 2 baseline):
- WARNING if top session growth >= 8000 tokens since last check OR total growth >= 25000.
- CRITICAL if top session growth >= 14000 tokens OR total growth >= 50000.

Steps:
1) Call session_status and capture usage-left snippet.
2) Run one exec command that:
   - loads previous state JSON (if missing use empty)
   - runs `openclaw sessions --all-agents --active 180 --json`
   - computes per-session growth and total growth
   - selects top contributors (top 3 by growth)
   - infers likely cause:
     - if top key contains ':cron:' => likely cron-driven burst
     - if top key contains ':telegram:' or ':discord:' => likely chat burst
     - else generic session burst
   - writes updated state back to reports/usage/state/option3-state.json
   - prints a single JSON result line
3) If no breach: reply NO_REPLY.
4) If breach:
   - send enriched alert with heading [OPTION 3 — Combined Threshold Alerts + Spike Context]
   - include severity, triggered rule, likely cause, top contributors, usage left, recommended action
   - append incident JSON to reports/usage/option3-incidents/incidents.jsonl
5) Reply NO_REPLY.
