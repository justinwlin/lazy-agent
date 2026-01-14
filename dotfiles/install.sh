#!/bin/bash
# Dotfiles installer for lazy-agent
# Symlinks configs to appropriate locations

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing dotfiles from $DOTFILES_DIR${NC}"
echo ""

# --- Helper: Analyze config differences ---
analyze_config() {
    local existing="$1"
    local new="$2"
    local name="$3"

    if [ ! -f "$existing" ]; then
        return 0  # No existing file, safe to proceed
    fi

    # If it's already a symlink to our dotfiles, skip analysis
    if [ -L "$existing" ]; then
        local target=$(readlink "$existing")
        if [[ "$target" == *"$DOTFILES_DIR"* ]]; then
            echo -e "  ${GREEN}Already linked to repo${NC}"
            return 0
        fi
    fi

    # Count custom lines (lines in existing but not in new)
    local custom_lines=$(diff "$existing" "$new" 2>/dev/null | grep "^<" | wc -l | tr -d ' ')
    local new_lines=$(diff "$existing" "$new" 2>/dev/null | grep "^>" | wc -l | tr -d ' ')

    if [ "$custom_lines" -gt 0 ]; then
        echo -e "  ${YELLOW}Warning: Found $custom_lines custom lines in your $name${NC}"
        echo -e "  ${YELLOW}These will be backed up but not automatically merged.${NC}"

        # Show preview of custom content
        echo -e "  ${BLUE}Your custom additions:${NC}"
        diff "$existing" "$new" 2>/dev/null | grep "^<" | head -5 | sed 's/^< /    /'
        if [ "$custom_lines" -gt 5 ]; then
            echo -e "    ${BLUE}... and $((custom_lines - 5)) more lines${NC}"
        fi
        echo ""

        # Ask for confirmation unless --force is passed
        if [ "$FORCE_INSTALL" != "true" ]; then
            read -p "  Proceed with backup and replace? (y/n/d for diff) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Dd]$ ]]; then
                echo -e "\n${BLUE}Full diff (your config vs repo):${NC}"
                diff "$existing" "$new" || true
                echo ""
                read -p "  Proceed with backup and replace? (y/n) " -n 1 -r
                echo
            fi
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo -e "  ${YELLOW}Skipping $name${NC}"
                return 1
            fi
        fi
    fi

    return 0
}

# --- tmux ---
echo -e "${GREEN}[tmux]${NC}"
if analyze_config ~/.tmux.conf "$DOTFILES_DIR/.tmux.conf" "~/.tmux.conf"; then
    if [ -f ~/.tmux.conf ] && [ ! -L ~/.tmux.conf ]; then
        echo -e "  Backing up to ~/.tmux.conf.backup"
        cp ~/.tmux.conf ~/.tmux.conf.backup
    fi
    ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
    echo -e "  ${GREEN}Linked ~/.tmux.conf${NC}"
fi

# --- Ghostty ---
echo -e "${GREEN}[Ghostty]${NC}"
mkdir -p ~/.config/ghostty
if analyze_config ~/.config/ghostty/config "$DOTFILES_DIR/.config/ghostty/config" "Ghostty config"; then
    if [ -f ~/.config/ghostty/config ] && [ ! -L ~/.config/ghostty/config ]; then
        echo -e "  Backing up to ~/.config/ghostty/config.backup"
        cp ~/.config/ghostty/config ~/.config/ghostty/config.backup
    fi
    ln -sf "$DOTFILES_DIR/.config/ghostty/config" ~/.config/ghostty/config
    echo -e "  ${GREEN}Linked ~/.config/ghostty/config${NC}"
fi

# --- Karabiner (optional) ---
if [ "$1" = "--with-karabiner" ] || [ "$INSTALL_KARABINER" = "true" ]; then
    echo -e "${GREEN}[Karabiner]${NC}"
    mkdir -p ~/.config/karabiner
    if analyze_config ~/.config/karabiner/karabiner.json "$DOTFILES_DIR/.config/karabiner/karabiner.json" "Karabiner config"; then
        if [ -f ~/.config/karabiner/karabiner.json ] && [ ! -L ~/.config/karabiner/karabiner.json ]; then
            echo -e "  Backing up to ~/.config/karabiner/karabiner.json.backup"
            cp ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.backup
        fi
        ln -sf "$DOTFILES_DIR/.config/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
        echo -e "  ${GREEN}Linked ~/.config/karabiner/karabiner.json${NC}"
    fi
else
    echo -e "${BLUE}[Karabiner]${NC} Skipped (use --with-karabiner to include)"
fi

# --- TPM (Tmux Plugin Manager) ---
echo -e "${GREEN}[TPM]${NC}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "  Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo -e "  ${GREEN}TPM installed. Run 'prefix + I' in tmux to install plugins.${NC}"
else
    echo -e "  ${GREEN}Already installed${NC}"
fi

echo ""
echo -e "${GREEN}Done!${NC} Restart your terminal or run:"
echo "  tmux source ~/.tmux.conf"
echo ""
echo "Note: Tmux prefix is Ctrl+A (or Caps Lock+A with Karabiner)"
echo ""
echo -e "${BLUE}Backups saved with .backup extension if any files were replaced.${NC}"
