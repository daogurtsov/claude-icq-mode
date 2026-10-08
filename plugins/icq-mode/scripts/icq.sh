#!/usr/bin/env bash
# Hook handler for icq-mode. Usage: icq.sh <session-start|prompt|stop|notify|status <name>>

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_DIR="${TMPDIR:-/tmp}/claude-icq"
mkdir -p "$STATE_DIR"

INPUT=""
[ -t 0 ] || INPUT="$(cat)"

session_id() {
  if command -v jq >/dev/null 2>&1 && [ -n "$INPUT" ]; then
    jq -r '.session_id // "default"' <<<"$INPUT" 2>/dev/null
  else
    echo default
  fi
}

set_status() {
  echo "$1" >"$STATE_DIR/$(session_id).status"
}

play() {
  [ "${CLAUDE_ICQ_SOUND:-1}" = "0" ] && return
  local f="$ROOT/sounds/$1.wav"
  [ -f "$f" ] || return
  if command -v afplay >/dev/null 2>&1; then
    (afplay "$f" >/dev/null 2>&1 &)
  elif command -v paplay >/dev/null 2>&1; then
    (paplay "$f" >/dev/null 2>&1 &)
  elif command -v aplay >/dev/null 2>&1; then
    (aplay -q "$f" >/dev/null 2>&1 &)
  fi
}

case "$1" in
  session-start)
    set_status online
    play online
    printf '{"systemMessage":"✿ Connecting… ✿ Claude is now Online. Type to start a conversation :-)"}\n'
    ;;
  prompt)
    set_status occupied
    printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"ICQ clock: %s"}}\n' "$(date +%H:%M)"
    ;;
  stop)
    set_status online
    play message
    ;;
  notify)
    set_status away
    play attention
    ;;
esac
exit 0
