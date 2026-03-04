#!/usr/bin/env bash
set -euo pipefail
WORKTREE="/home/kernk/.openclaw-docker-clone/state/workspace-twin"
LOG_DIR="$WORKTREE/automation/logs"
MODE="${1:-auto}"
mkdir -p "$LOG_DIR"
TS_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LOG_FILE="$LOG_DIR/git-snapshot.log"
{
  echo "[$TS_UTC] snapshot start mode=$MODE"
  cd "$WORKTREE"
  git config --local user.name "Abby Bot"
  git config --local user.email "abby-bot@local"
  git remote get-url origin >/dev/null
  TRACKED_PATHS=(
    "AGENTS.md"
    "SOUL.md"
    "USER.md"
    "TOOLS.md"
    "IDENTITY.md"
    "HEARTBEAT.md"
    "BOOT.md"
    "memory"
    "automation"
    "reports"
  )
  for p in "${TRACKED_PATHS[@]}"; do
    [[ -e "$p" ]] && git add -A -- "$p"
  done
  HAS_CHANGES=0
  if [[ -n "$(git status --porcelain -- "${TRACKED_PATHS[@]}")" ]]; then
    HAS_CHANGES=1
    MSG="snapshot($MODE): $(date +"%Y-%m-%d %H:%M %Z")"
    git commit -m "$MSG"
  else
    echo "[$TS_UTC] no tracked changes"
  fi
  BRANCH="$(git branch --show-current 2>/dev/null || true)"
  [[ -n "$BRANCH" ]] || BRANCH="master"
  if ! git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
    git push -u origin "$BRANCH"
  else
    AHEAD="$(git rev-list --left-right --count @{u}...HEAD | awk '{print $2}')"
    if [[ "${AHEAD:-0}" -gt 0 || "$HAS_CHANGES" -eq 1 ]]; then
      git push origin "$BRANCH"
    else
      echo "[$TS_UTC] nothing pending for push"
    fi
  fi
  echo "[$TS_UTC] snapshot success"
} >> "$LOG_FILE" 2>&1
