#!/bin/bash
# Lazy Agent - Interactive Setup
# Terminal environment for AI-powered development

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      ${GREEN}Lazy Agent Setup Wizard${BLUE}          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""
echo "Like LazyVim, but for terminal-based AI workflows."
echo ""

# Check if gum is installed for pretty prompts
if command -v gum &> /dev/null; then
    USE_GUM=true
else
    USE_GUM=false
    echo -e "${YELLOW}Tip: Install 'gum' for a prettier experience: brew install gum${NC}"
    echo ""
fi

# Helper functions
prompt() {
    local question="$1"
    local default="$2"
    if [ "$USE_GUM" = true ]; then
        gum input --placeholder "$default" --prompt "$question "
    else
        read -p "$question [$default]: " answer
        echo "${answer:-$default}"
    fi
}

confirm() {
    local question="$1"
    if [ "$USE_GUM" = true ]; then
        gum confirm "$question" && echo "true" || echo "false"
    else
        read -p "$question [y/N]: " answer
        [[ "$answer" =~ ^[Yy] ]] && echo "true" || echo "false"
    fi
}

# Gather info
NAME=$(prompt "What's your name?" "Developer")

echo ""
echo -e "${CYAN}=== Core Setup ===${NC}"
echo "These are installed for everyone:"
echo "  - Ghostty (terminal emulator)"
echo "  - Zsh + Oh My Zsh + Powerlevel10k"
echo "  - tmux (terminal multiplexer)"
echo "  - Claude Code"
echo ""

echo -e "${CYAN}=== Keyboard Optimization ===${NC}"
INSTALL_KARABINER=$(confirm "Install Karabiner? (Caps Lock → Escape/Ctrl, great for vim/tmux)")

echo ""
echo -e "${CYAN}=== Terminal Enhancements ===${NC}"
INSTALL_POWERTOOLS=$(confirm "Install terminal power tools? (fzf, bat, eza, jq, httpie)")

echo ""
echo -e "${CYAN}=== Optional Integrations ===${NC}"
INSTALL_NOTION=$(confirm "Do you use Notion? (enables Claude to search your docs)")
INSTALL_LINEAR=$(confirm "Do you use Linear? (enables Claude to manage issues)")

echo ""
echo -e "${CYAN}=== Developer Tools ===${NC}"
INSTALL_PLAYWRIGHT=$(confirm "Install Playwright? (browser automation)")
INSTALL_GCALCLI=$(confirm "Install gcalcli? (Google Calendar in terminal)")

echo ""
echo -e "${CYAN}=== Multi-Agent Tools ===${NC}"
echo "These help coordinate multiple Claude sessions:"
INSTALL_GASTOWN=$(confirm "Install Gastown? (multi-agent workspace coordination)")
INSTALL_BEADS=$(confirm "Install Beads? (git-backed issue tracking)")

# Generate config.json
echo ""
echo -e "${GREEN}Generating config.json...${NC}"

cat > config.json << EOF
{
  "user": {
    "name": "$NAME"
  },
  "dotfiles": {
    "use_included": true,
    "install_karabiner": $INSTALL_KARABINER
  },
  "setup": {
    "optional_tools": {
      "karabiner": $INSTALL_KARABINER,
      "terminal_power_tools": $INSTALL_POWERTOOLS,
      "playwright": $INSTALL_PLAYWRIGHT,
      "gcalcli": $INSTALL_GCALCLI,
      "gastown": $INSTALL_GASTOWN,
      "beads": $INSTALL_BEADS,
      "linear_mcp": $INSTALL_LINEAR,
      "notion_mcp": $INSTALL_NOTION
    }
  },
  "preferences": {
    "shell": "zsh",
    "editor": "neovim",
    "theme": "dark"
  }
}
EOF

echo -e "${GREEN}Created config.json${NC}"
echo ""

# Install dotfiles
if [ "$(confirm "Install dotfiles now? (tmux config, Ghostty settings)")" = "true" ]; then
    if [ "$INSTALL_KARABINER" = "true" ]; then
        ./dotfiles/install.sh --with-karabiner
    else
        ./dotfiles/install.sh
    fi
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Setup Complete!             ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo ""
echo "  1. Start Claude Code:"
echo -e "     ${CYAN}claude${NC}"
echo ""
echo "  2. Say:"
echo -e "     ${CYAN}help me get started${NC}"
echo ""
echo "Claude will guide you through installing everything else."
echo ""
