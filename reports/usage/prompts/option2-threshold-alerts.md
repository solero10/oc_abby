[usage-option-2] Threshold watcher every 20 minutes.

Requirements:
- Reply exactly NO_REPLY at the end.
- Silent unless threshold breach.
- Output must include usage-left values from session_status format.
- Send alerts to Discord channel #usage (id: 1480677127182614548) using channel=discord,target=1480677127182614548.
- Append machine-readable event lines to reports/usage/option2-alerts/alerts.jsonl.
- Persist watcher state at reports/usage/state/option2-state.json.

Thresholds:
- WARNING if top session growth >= 8000 tokens since last check OR total growth >= 25000.
- CRITICAL if top session growth >= 14000 tokens OR total growth >= 50000.

Steps:
1) Call session_status and capture usage-left snippet.
2) Run one exec command that:
   - loads previous state JSON (if missing use empty)
   - runs `openclaw sessions --all-agents --active 180 --json`
   - computes per-session token growth vs previous snapshot
   - computes total growth across all tracked sessions
   - determines alert severity/rule based on thresholds
   - writes updated state back to reports/usage/state/option2-state.json
   - prints a single JSON result line
3) If no breach: reply NO_REPLY.
4) If breach:
   - send alert message with heading [OPTION 2 — Threshold Alerts]
   - include severity, triggered rule, top source session, growth amount, usage left
   - append JSON event to reports/usage/option2-alerts/alerts.jsonl
5) Reply NO_REPLY.
