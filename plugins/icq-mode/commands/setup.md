---
description: Turn on the ICQ-style status bar and output style in your user settings
allowed-tools: Read, Edit, Write, Bash(chmod:*)
---

Enable icq-mode for the user. Do this:

1. Run `chmod +x "${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh"`.
2. Read `~/.claude/settings.json` (create it as `{}` if it does not exist).
3. Show the user the exact changes below and ask for confirmation before writing. If a `statusLine` is already configured, mention that it will be replaced.
   - Set `statusLine` to `{ "type": "command", "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/statusline.sh\"" }`, with `${CLAUDE_PLUGIN_ROOT}` expanded to its absolute path.
   - Set `outputStyle` to `icq-mode:ICQ`.
4. Preserve every other key in the file.
5. Tell the user to start a new session (or run `/output-style`) to see the ICQ chat window, and that `CLAUDE_ICQ_SOUND=0` mutes the sounds.

$ARGUMENTS
