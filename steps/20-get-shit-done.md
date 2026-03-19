---
title: Get Shit Done (GSD) - Meta-Prompting System
time_estimate: 1 min
required: false
recommended: true
dependencies:
  - "05"
tags:
  - recommended
---

# Step 20: Get Shit Done (GSD) - Meta-Prompting System

GSD is a meta-prompting, context engineering, and spec-driven development system for Claude Code. It solves context rot — the quality degradation that happens as Claude fills its context window.

**Time estimate: ~1 minute**
**Type: RECOMMENDED** - Dramatically improves Claude Code output quality for larger projects

---

## Why This Matters

When you give Claude Code a big task, quality degrades as the context window fills up. GSD fixes this by:

- **Breaking work into context-window-sized tasks** - Each task gets a fresh 200k token window
- **Structured planning** - Questions → Research → Requirements → Roadmap → Execute
- **Parallel execution** - Independent tasks run simultaneously in separate context windows
- **Atomic commits** - Every task gets its own clean git commit
- **Automatic verification** - Checks that the work actually matches the plan

Think of it as a project manager for Claude Code that ensures consistent quality from start to finish.

---

## What We're Installing

**get-shit-done-cc** - A prompt framework that installs slash commands into Claude Code.

GitHub: https://github.com/gsd-build/get-shit-done

---

## Step 1: Check If Already Installed

```bash
ls ~/.claude/commands/gsd* 2>/dev/null && echo "GSD: installed" || echo "Not installed yet"
```

---

## Step 2: Install GSD

```bash
npx get-shit-done-cc@latest
```

The installer will prompt you to choose:
1. **Runtime** — Claude Code (select this), or others like Gemini CLI, Codex, etc.
2. **Location** — Global (all projects) or local (current project only)

**For most users, choose: Claude Code + Global.**

**Non-interactive install:**

```bash
npx get-shit-done-cc@latest --claude --global
```

---

## Step 3: Verify Installation

Open Claude Code and run:

```
/gsd:help
```

You should see the list of GSD commands.

---

## Step 4: How to Use GSD

### The Core Workflow

```
/gsd:new-project          # 1. Describe your idea, GSD asks questions
/gsd:discuss-phase 1      # 2. Shape how phase 1 should be implemented
/gsd:plan-phase 1         # 3. Research + create atomic task plans
/gsd:execute-phase 1      # 4. Execute plans (parallel where possible)
/gsd:verify-work 1        # 5. Walk through and verify it works
/gsd:ship 1               # 6. Create PR from verified work
```

Repeat for each phase until your project is complete.

### Quick Mode (For Smaller Tasks)

```
/gsd:quick                # Skip full planning, just get it done
```

Quick mode gives you GSD guarantees (atomic commits, state tracking) with a faster path. Great for ad-hoc tasks.

### Already Have Code?

```
/gsd:map-codebase         # Analyze existing code first
/gsd:new-project          # Then plan new features with full context
```

### Auto-Detect Next Step

```
/gsd:next                 # GSD figures out what to do next
```

---

## Key Commands

| Command | Description |
|---------|-------------|
| `/gsd:new-project` | Start a new project with guided questions |
| `/gsd:map-codebase` | Analyze existing codebase before planning |
| `/gsd:discuss-phase N` | Shape implementation details for a phase |
| `/gsd:plan-phase N` | Research and create task plans |
| `/gsd:execute-phase N` | Execute plans with fresh context per task |
| `/gsd:verify-work N` | Walk through and verify deliverables |
| `/gsd:ship N` | Create PR from verified work |
| `/gsd:quick` | Quick mode for ad-hoc tasks |
| `/gsd:next` | Auto-detect and run next step |
| `/gsd:help` | Show all available commands |

---

## How It Works Under the Hood

1. **Questions** — Asks until it fully understands your idea
2. **Research** — Spawns parallel agents to investigate the domain
3. **Requirements** — Extracts v1, v2, and out-of-scope items
4. **Roadmap** — Creates phases mapped to requirements
5. **Planning** — Breaks phases into atomic, context-window-sized tasks
6. **Execution** — Each task runs in a fresh context window
7. **Verification** — Automated checks + manual walkthrough

Files are stored in `.planning/` directory:
- `PROJECT.md` - Project description
- `REQUIREMENTS.md` - Extracted requirements
- `ROADMAP.md` - Phase breakdown
- `STATE.md` - Current progress

---

## Staying Updated

GSD evolves fast. Update periodically:

```bash
npx get-shit-done-cc@latest
```

---

## Troubleshooting

### Commands not showing up?

Make sure you installed globally:

```bash
npx get-shit-done-cc@latest --claude --global
```

Then restart Claude Code.

### Want to start over?

Remove the planning directory:

```bash
rm -rf .planning/
```

---

## Success!

You now have GSD installed. Start any new project with `/gsd:new-project` and let the system guide you through building it properly.

---

## Next Steps

- Try `/gsd:new-project` on your next project
- Use `/gsd:quick` for smaller tasks
- Consider upgrading to **GSD 2** (step 21) for full autonomous execution
- Join the community: https://discord.gg/gsd
