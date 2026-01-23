# Step 15: Claude Notify - Desktop Notifications

Get desktop notifications when Claude Code finishes tasks, encounters errors, or needs input.

**Time estimate: 1-2 minutes**
**Type: RECOMMENDED** - Work in the background while Claude handles long tasks

---

## Why This Matters

Claude-notify sends desktop alerts so you can multitask while Claude runs long operations. You'll get notified when:
- A task completes successfully
- An error occurs that needs attention
- Claude needs your approval (for bash commands, etc.)

This is especially powerful with tmux - start Claude in one pane, work in another, and get notified when it's done.

---

## What We're Installing

**claude-notify** (`cn`) - A CLI tool that integrates with Claude Code to send native desktop notifications.

GitHub: https://github.com/mylee04/code-notify

---

## Step 1: Check What's Already Installed

First, let's see if you already have it:

```bash
which cn && cn status || echo "Not installed yet"
```

If you see version info, skip to Step 3 to enable it.

---

## Step 2: Install claude-notify

```bash
brew tap mylee04/tools
brew install claude-notify
```

Verify installation:

```bash
cn --help
```

You should see the help menu with available commands.

---

## Step 3: Enable Notifications Globally

```bash
cn on
```

This enables notifications for all Claude Code sessions across all projects.

---

## Step 4: Verify Configuration

```bash
cn status
```

You should see:
```
🔔 Notifications: enabled
📍 Config location: ~/.claude/settings.json
```

---

## Step 5: Test It Out

1. Open a new Claude Code session
2. Ask Claude to do something that takes a few seconds
3. Switch to another window/app
4. You should get a notification when Claude finishes or needs input

---

## Configuration Options

### Global vs Per-Project

**Global settings** (all projects):
```bash
cn on          # Enable globally
cn off         # Disable globally
```

**Per-project settings** (override global):
```bash
cnp on         # Enable for current project only
cnp off        # Disable for current project only
```

Project settings are stored in `.claude/settings.json` in your project root.

### Voice Notifications (macOS only)

Want Claude to speak when tasks complete?

```bash
cnp voice on         # Enable voice alerts
cnp voice off        # Disable voice alerts
```

The voice name is stored in `~/.claude/notifications/voice-enabled`.

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `cn on` | Enable notifications globally |
| `cn off` | Disable notifications globally |
| `cnp on` | Enable for current project only |
| `cnp off` | Disable for current project |
| `cn status` | Check current configuration |
| `cnp voice on` | Enable voice alerts (macOS) |
| `cnp voice off` | Disable voice alerts |

---

## Troubleshooting

### Notifications not appearing?

1. **Check if enabled**:
   ```bash
   cn status
   ```

2. **Check system permissions**:
   - macOS: System Settings → Notifications → Terminal (or Ghostty)
   - Make sure notifications are allowed

3. **Try toggling**:
   ```bash
   cn off
   cn on
   ```

4. **Restart Claude Code session**

### Voice not working?

1. Check voice is enabled:
   ```bash
   cat ~/.claude/notifications/voice-enabled
   ```

2. Test macOS text-to-speech:
   ```bash
   say "Testing voice notifications"
   ```

3. If no voice is set, enable it:
   ```bash
   cnp voice on
   ```

---

## Tips

1. **Use with tmux**: Start Claude in one pane (`Ctrl+b |`), work in another, get notified when done
2. **Long-running tasks**: Perfect for build processes, test suites, or complex refactors
3. **Background work**: Let Claude work while you check Slack, review PRs, etc.

---

## Success!

You should now see desktop notifications when:
- ✅ Tasks complete successfully
- ❌ Errors occur
- ❓ Claude needs your input or approval

Try it out by asking Claude to run a task that takes a few seconds, then switch windows. You'll get notified when it's ready!

---

## Next Steps

- **Step 16**: Get Shit Done (GSD) - Meta-prompting for structured projects [OPTIONAL]
- **Step 17**: Fork - Parallel Claude instances for exploring multiple approaches [QUICK]

Or ask: "What should I learn next?"
