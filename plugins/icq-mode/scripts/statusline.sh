#!/usr/bin/env bash
# Status line for icq-mode: ✿ flower status, UIN, folder and model.

INPUT="$(cat)"
STATE_DIR="${TMPDIR:-/tmp}/claude-icq"

field() {
  jq -r "$1 // empty" <<<"$INPUT" 2>/dev/null
}

SESSION="$(field .session_id)"
MODEL="$(field .model.display_name)"
DIR="$(field .workspace.current_dir)"
STATUS="$(cat "$STATE_DIR/${SESSION:-default}.status" 2>/dev/null || echo online)"

case "$STATUS" in
  occupied) COLOR='\033[31m'; LABEL='Occupied' ;;
  away)     COLOR='\033[33m'; LABEL='Away' ;;
  *)        COLOR='\033[32m'; LABEL='Online' ;;
esac

UIN="$(printf '%s' "${SESSION:-claude}" | cksum | cut -d' ' -f1)"
UIN="$(printf '%09d' "$((UIN % 1000000000))")"
UIN="${UIN:0:3}-${UIN:3:3}-${UIN:6:3}"

GREY='\033[90m'
RESET='\033[0m'
SEP="${GREY} │ ${RESET}"

LINE="${COLOR}✿${RESET} Claude ${COLOR}${LABEL}${RESET}${SEP}${GREY}UIN${RESET} ${UIN}"
[ -n "$DIR" ] && LINE="${LINE}${SEP}📁 $(basename "$DIR")"
[ -n "$MODEL" ] && LINE="${LINE}${SEP}${MODEL}"

printf '%b\n' "$LINE"
