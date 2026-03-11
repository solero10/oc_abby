[usage-option-1] Build and send the scheduled usage digest (runs 3x daily: 7:00, 13:00, 20:00 America/Los_Angeles).

Requirements:
- Reply exactly NO_REPLY at the end.
- Use tools directly; do not ask the user questions.
- Output must include usage-left values from session_status format.
- Send to Telegram target 7729039890.
- Save archive copy to workspace path reports/usage/option1-digests/YYYY-MM-DD-HHMM.md (to avoid overwriting when run 3x/day).

Steps:
1) Call session_status and capture usage-left snippet (5h and Day left).
2) Run:
   openclaw sessions --all-agents --active 480 --json
   Then summarize:
   - total sessions in window
   - top 5 sessions by totalTokens
   - top agents by session count
   - concise plain-language summary
3) Create a markdown digest with heading:
   [OPTION 1 — Scheduled Digest]
   Include:
   - Window (previous 8h)
   - Usage left
   - Top contributors
   - Short summary
4) Write the digest file to reports/usage/option1-digests/<YYYY-MM-DD-HHMM>.md
5) Send the digest text via message tool to telegram 7729039890.
6) Reply NO_REPLY.
