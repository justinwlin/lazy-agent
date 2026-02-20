---
title: RTK - Token Optimization
time_estimate: 1 min
required: false
recommended: true
dependencies:
  - "05"
tags:
  - quick
---

# Step 18: RTK - Token Optimization

RTK (Rust Token Killer) is a CLI proxy that filters and compresses command output before it reaches Claude's context window. It saves 60-90% of tokens on common dev operations.

**Time estimate: ~1 minute**
**Type: RECOMMENDED** - Significant token savings on every Claude Code session

---

## Why This Matters

Every command Claude runs (git status, ls, test output) consumes tokens from the context window. Most of that output is noise - whitespace, comments, redundant lines. RTK intercepts these commands and returns only what matters:

- `git push` output (200+ tokens) becomes "ok main" (~10 tokens)
- Large test suites get summarized with pass/fail counts
- Git diffs drop noise and keep meaningful changes

Over a session, this adds up to 60-90% fewer tokens spent on command output - meaning more room for actual coding work.

---

## What We're Installing

**RTK** (`rtk`) - A Rust-based CLI proxy with smart filtering, grouping, truncation, and deduplication.

GitHub: https://github.com/rtk-ai/rtk

---

## Step 1: Check If Already Installed

```bash
which rtk && rtk --version || echo "Not installed yet"
```

If installed, verify it's the right one (there's a name collision with "Rust Type Kit"):

```bash
rtk gain
```

If `rtk gain` works, you have the correct package. Skip to Step 3.

---

## Step 2: Install RTK

**Quick install (recommended):**

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
```

This downloads a prebuilt binary to `~/.local/bin`. Make sure it's in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

**Alternative - Homebrew:**

```bash
brew install rtk
```

**Alternative - Build from source (requires Rust):**

```bash
cargo install --git https://github.com/rtk-ai/rtk
```

Verify installation:

```bash
rtk --version
```

---

## Step 3: Set Up Claude Code Hook

RTK integrates with Claude Code via a hook that transparently rewrites commands:

```bash
rtk init --global
```

This does three things:
1. Deploys a PreToolUse hook to `~/.claude/hooks/rtk-rewrite.sh`
2. Patches `~/.claude/settings.json` to register the hook
3. Creates a minimal `RTK.md` reference file

Verify the hook is installed:

```bash
rtk init --show
```

---

## Step 4: Test It

Try a proxied command:

```bash
rtk git status
```

Compare with the raw output:

```bash
rtk proxy git status
```

You should see significantly less output from the proxied version.

---

## Commands Reference

### Meta Commands (use directly)

| Command | Description |
|---------|-------------|
| `rtk gain` | Show token savings analytics |
| `rtk gain --history` | Show command usage history with savings |
| `rtk discover` | Analyze Claude Code history for missed opportunities |
| `rtk proxy <cmd>` | Execute command without filtering (for debugging) |

### How It Works in Practice

Once the hook is installed, you don't need to do anything. Claude's commands are automatically rewritten:

| What Claude runs | What actually executes |
|-----------------|----------------------|
| `git status` | `rtk git status` |
| `git diff` | `rtk git diff` |
| `ls -la` | `rtk ls -la` |

This is completely transparent - zero tokens overhead, 60-90% savings on output.

---

## Troubleshooting

### Wrong package installed?

If `rtk gain` doesn't work but `rtk --version` does, you may have the wrong `rtk` (Rust Type Kit):

```bash
which rtk
# If it points to a cargo-installed binary, uninstall it:
cargo uninstall rtk
# Then install the correct one:
brew install rtk
```

### Hook not working?

Check the hook is registered:

```bash
rtk init --show
```

If needed, re-run the setup:

```bash
rtk init --global
```

### Want to see unfiltered output?

Use `rtk proxy` to bypass filtering:

```bash
rtk proxy git status
```

---

## Success!

Run `rtk gain` to see your token savings dashboard. As you use Claude Code, the savings will accumulate automatically.

---

## Next Steps

RTK works automatically in the background - no workflow changes needed. Just use Claude Code as normal and enjoy the token savings.

Check your savings anytime with `rtk gain`.
