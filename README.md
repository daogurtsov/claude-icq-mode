# ✿ claude-icq-mode

> Talk to Claude Code like it's 1999.

A [Claude Code](https://claude.com/claude-code) plugin that gives the CLI the look and feel of a classic 90s instant messenger in the spirit of ICQ: replies arrive as chat-window messages, a flower in the status bar shows whether Claude is **Online**, **Occupied** or **Away**, and a retro chime plays when a new message comes in.

```
✿ Claude (14:32):
Hey buddy! Found the bug :-) The reducer was mutating state in place.

_✿ Claude changed status to **Occupied** (working on it…)_

✿ Claude:
Fixed and the build is green 8-)

📁 File transfer complete:
   • src/reducers/cart.js   (modified)

_✿ Claude is **Online**_
──────────────────────────────────────────────────────────────
✿ Claude Online │ UIN 482-913-077 │ 📁 my-app │ Opus 5.5
```

## Features

| | |
|---|---|
| 💬 **ICQ output style** | Every reply is a chat message with a `✿ Claude (HH:MM):` header, short IM-sized bubbles, classic `:-)` emoticons, status-change notices, an **Uh-oh!** on errors, and a "file transfer complete" summary of changed files. Code, diffs and technical content are never altered. |
| ✿ **Flower status bar** | Green **Online** when idle, red **Occupied** while Claude works, yellow **Away** when Claude is waiting on you. Each session gets its own UIN. |
| 🔔 **Sounds** | Login chime on session start, "incoming message" blip when Claude finishes, attention tone when Claude needs you. All sounds are original, synthesized by `scripts/gen-sounds.py`. |

## Install

Inside Claude Code:

```
/plugin marketplace add daogurtsov/claude-icq-mode
/plugin install icq-mode@claude-icq-mode
/icq-mode:setup
```

`/icq-mode:setup` turns on the status bar and selects the `icq-mode:ICQ` output style in `~/.claude/settings.json` (it asks before writing). Start a new session to log on. You can also switch styles any time with `/output-style`.

### Requirements

- `bash` and `jq` (status bar + hooks)
- Sounds: `afplay` (macOS) or `paplay` / `aplay` (Linux). Set `CLAUDE_ICQ_SOUND=0` to mute.

## How it works

```
plugins/icq-mode/
├── output-styles/icq.md     # the chat-window persona/format
├── hooks/hooks.json         # SessionStart / UserPromptSubmit / Stop / Notification
├── scripts/icq.sh           # updates status state, injects the chat clock, plays sounds
├── scripts/statusline.sh    # renders the ✿ status bar
├── scripts/gen-sounds.py    # regenerates sounds/*.wav
└── commands/setup.md        # /icq-mode:setup
```

The hooks write the current status to `$TMPDIR/claude-icq/<session>.status`, and the status line reads it on every refresh. `UserPromptSubmit` injects `ICQ clock: HH:MM` so message headers show the real local time.

## Uninstall

```
/plugin uninstall icq-mode@claude-icq-mode
```

Then remove `statusLine` and `outputStyle` from `~/.claude/settings.json` (or pick another style with `/output-style`).

## Disclaimer

This is an unofficial, fan-made nostalgia project. It is not affiliated with, endorsed by, or connected to ICQ or its owners. "ICQ" is used only to describe the inspiration; no original ICQ assets (logos, sounds) are included.

## License

[MIT](LICENSE)
