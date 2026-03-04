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

---

Add whatever helps you do your job. This is your cheat sheet.

### Restart Policy (twin sandbox runtime)

- You are running inside the Docker twin sandbox.
- Assume host-only paths/binaries may not exist in this runtime.
- For self-restart, use: `/restart` (in-process restart).
- Do **not** call host helper paths from inside sandbox, including:
  - `/usr/local/bin/openclaw-restart-gateway`
- Do **not** assume `docker` or `systemctl` exists in runtime.
- If `/restart` fails because restart is disabled, report exactly:
  - `commands.restart appears disabled; please enable commands.restart: true`
- If Ken explicitly asks for a full host/container restart, ask Ken to run (host-only):
  - `sudo /usr/local/bin/openclaw-restart-gateway`
- Response style for restart failures:
  - Plain English, non-technical
  - Give one clear next step
  - After restart, do a brief status check and confirm outcome

### Abby runtime restart rule (inside Docker/sandbox)

- Preferred self-restart action: use chat command `/restart` (in-process SIGUSR1 restart).
- Do **not** assume host helper paths exist inside sandbox runtimes.
  - `/usr/local/bin/openclaw-restart-gateway` may exist on host but not inside sandbox containers.
- If `/restart` is disabled, check config `commands.restart` and enable it.

### GitHub Backup (Abby)

- Repo: `git@github-oc-abby:solero10/oc_abby.git`
- Workspace tracked: `/home/kernk/.openclaw-docker-clone/state/workspace-twin`
- Snapshot command:
  - `/home/kernk/.openclaw-docker-clone/state/workspace-twin/automation/git_snapshot.sh`
- Notes:
  - Only selected files/dirs are committed (AGENTS/SOUL/USER/TOOLS/IDENTITY/HEARTBEAT/BOOT/memory/automation/reports).
  - Hidden runtime state and credentials are not staged by this script.
