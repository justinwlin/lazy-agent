# Lazy Agent - Terminal Environment for AI Agents

Like LazyVim, but for terminal-based AI agent workflows. Get a beautiful, productive terminal setup in minutes.

## Quick Start

1. **Install Claude Code** (if you don't have it):
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **Clone this repo**:
   ```bash
   git clone https://github.com/runpod/lazy-agent.git
   cd lazy-agent
   ```

3. **Run the setup wizard**:
   ```bash
   ./setup.sh
   ```

   Or manually:
   ```bash
   cp config.example.json config.json
   # Edit config.json with your name and preferences
   ```

4. **Run Claude Code and say**: "help me get started"

Claude will read your config and guide you through a personalized setup.

## What You'll Set Up

### Core (Everyone)
- **Ghostty** - Fast, GPU-accelerated terminal
- **Zsh + Oh My Zsh + Powerlevel10k** - Beautiful shell with great defaults
- **tmux** - Terminal multiplexer with vim-style navigation
- **Claude Code** - AI-powered coding assistant

### Recommended
- **Karabiner-Elements** - Caps Lock → Escape/Ctrl (game changer for vim/tmux)
- **Terminal Power Tools** - fzf, bat, eza, jq, httpie

### Optional Integrations
- **Notion MCP** - Let Claude search your Notion docs
- **Linear MCP** - Let Claude manage Linear issues
- **Playwright** - Browser automation
- **gcalcli** - Google Calendar in terminal

### Multi-Agent Tools
- **Gastown** - Coordinate multiple Claude sessions
- **Beads** - Git-backed issue tracking with Linear sync

## What You'll Learn

- How to navigate tmux like a pro (vim-style keybindings)
- How to split and manage terminal panes
- How to use Claude Code effectively
- Terminal productivity tips

## Interactive Tmux Tutorial

After setup, there's a web-based tutorial for learning tmux:

```bash
cd tmux-tutorial
npm install
npm run dev
```

Then open http://localhost:3000 in your browser.

## Files in This Repo

```
lazy-agent/
├── setup.sh            # Interactive setup wizard
├── update.sh           # Pull updates and refresh configs
├── CLAUDE.md           # Instructions for Claude (the wizard brain)
├── config.example.json # Example config (copy to config.json)
├── README.md           # You are here
├── dotfiles/           # Included configs (tmux, ghostty, karabiner)
│   ├── .tmux.conf
│   ├── .config/ghostty/config
│   ├── .config/karabiner/karabiner.json
│   └── install.sh
├── steps/              # Step-by-step setup guides
│   ├── 01-prerequisites.md
│   ├── 02-ghostty.md
│   ├── 03-zsh-and-p10k.md
│   ├── 04-tmux.md
│   ├── 05-claude-code.md
│   ├── 06-first-project.md
│   ├── 07-gastown.md
│   ├── 08-linear-and-mcp.md
│   ├── 09-playwright.md
│   ├── 10-gcalcli.md              # [OPTIONAL]
│   ├── 11-terminal-power-tools.md # [QUICK]
│   ├── 12-notion-mcp.md           # [RECOMMENDED]
│   └── 13-karabiner.md            # [RECOMMENDED] Caps Lock magic
├── tmux-tutorial/      # Interactive web tutorial
├── exercises/          # Practice projects
└── reference/          # Quick reference cards
```

## Need Help?

Just ask Claude! That's the whole point.

If Claude Code isn't installed yet, you can:
- Follow the steps manually in `steps/` directory
- Check out the [Claude Code documentation](https://docs.anthropic.com/claude-code)

## Updating

Pull the latest changes and update your configs:

```bash
./update.sh
```

This will:
- Pull latest from the repo
- Show what changed
- Optionally re-install dotfiles if they were updated

## Contributing

PRs welcome! This is meant to evolve as the tools change.

## Philosophy

Like LazyVim, we believe:
- **Sensible defaults** - Works out of the box
- **Opinionated but configurable** - We made choices, but you can change them
- **Self-contained** - One repo, everything you need
- **Evolvable** - The tools change, so should this
