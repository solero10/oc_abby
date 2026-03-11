# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

## Abby Ops Notes

- For non-workspace OpenClaw runtime files (for example `~/.openclaw/proxy/*`, `~/.openclaw/*.json`, `~/.openclaw/agents/*`), prefer deterministic patching (`python`/`sed`/write) over `edit` tool replacements.
- Before modifying non-workspace files, do a quick existence/read check first.
- After patching, validate with a targeted check (`rg` for old path/value, syntax check when relevant).

---

Add whatever helps you do your job. This is your cheat sheet.

## Restart helper
- Reliable restart+notify script: ~/.openclaw/bin/restart-with-backup-notify.sh
- Behavior: sends 5-second pre-notice, restarts gateway, waits for health, sends exact "I am back up" first, then sends verification message.
