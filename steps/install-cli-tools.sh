#!/usr/bin/env bash
# install-cli-tools.sh
# Downloads prebuilt binaries for Rust-based CLI tools when Homebrew bottles
# aren't available (common on older macOS versions like Ventura).
#
# Usage: ./steps/install-cli-tools.sh

set -euo pipefail

INSTALL_DIR="/usr/local/bin"
TMPDIR_BASE="${TMPDIR:-/tmp}/cli-tools-install"
mkdir -p "$TMPDIR_BASE"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
  RUST_ARCH="aarch64"
else
  RUST_ARCH="x86_64"
fi

echo "Detected architecture: $ARCH ($RUST_ARCH)"
echo "Install directory: $INSTALL_DIR"
echo ""

install_from_tarball() {
  local name="$1"
  local url="$2"
  local binary_name="$3"
  local strip="${4:-1}" # strip components (default 1 for tools that wrap in a dir)

  if command -v "$binary_name" &>/dev/null; then
    echo "✓ $name already installed ($(command -v "$binary_name"))"
    return 0
  fi

  echo "→ Installing $name..."
  local tmpfile="$TMPDIR_BASE/$name.tar.gz"
  local tmpextract="$TMPDIR_BASE/$name"
  mkdir -p "$tmpextract"

  curl -fsSL "$url" -o "$tmpfile"
  tar xzf "$tmpfile" -C "$tmpextract" --strip-components="$strip" 2>/dev/null \
    || tar xzf "$tmpfile" -C "$tmpextract"

  if [ -f "$tmpextract/$binary_name" ]; then
    sudo install -m 755 "$tmpextract/$binary_name" "$INSTALL_DIR/$binary_name"
    echo "✓ $name installed to $INSTALL_DIR/$binary_name"
  else
    # binary might be at top level after strip
    local found
    found=$(find "$tmpextract" -name "$binary_name" -type f | head -1)
    if [ -n "$found" ]; then
      sudo install -m 755 "$found" "$INSTALL_DIR/$binary_name"
      echo "✓ $name installed to $INSTALL_DIR/$binary_name"
    else
      echo "✗ $name: could not find binary '$binary_name' in archive"
      return 1
    fi
  fi

  rm -rf "$tmpfile" "$tmpextract"
}

# ripgrep
install_from_tarball "ripgrep" \
  "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-15.1.0-${RUST_ARCH}-apple-darwin.tar.gz" \
  "rg"

# bat
install_from_tarball "bat" \
  "https://github.com/sharkdp/bat/releases/latest/download/bat-v0.26.1-${RUST_ARCH}-apple-darwin.tar.gz" \
  "bat"

# fd
install_from_tarball "fd" \
  "https://github.com/sharkdp/fd/releases/latest/download/fd-v10.3.0-${RUST_ARCH}-apple-darwin.tar.gz" \
  "fd"

# zoxide
install_from_tarball "zoxide" \
  "https://github.com/ajeetdsouza/zoxide/releases/latest/download/zoxide-0.9.9-${RUST_ARCH}-apple-darwin.tar.gz" \
  "zoxide" \
  0

# delta
install_from_tarball "delta" \
  "https://github.com/dandavison/delta/releases/latest/download/delta-0.18.2-${RUST_ARCH}-apple-darwin.tar.gz" \
  "delta"

# eza - no macOS prebuilt binary available from GitHub releases.
# Must use Homebrew (even if it builds from source) or cargo install.
if ! command -v eza &>/dev/null; then
  echo ""
  echo "→ eza: No prebuilt macOS binary available from GitHub."
  echo "  Options:"
  echo "    1) brew install eza  (may build from source — ~5 min)"
  echo "    2) cargo install eza (requires Rust toolchain)"
  echo "  Skipping for now. You can install it later with either command."
else
  echo "✓ eza already installed ($(command -v eza))"
fi

# httpie - Python-based, use pip
if ! command -v http &>/dev/null; then
  echo ""
  echo "→ Installing httpie via pip..."
  pip3 install --user httpie
  echo "✓ httpie installed"
else
  echo "✓ httpie already installed ($(command -v http))"
fi

echo ""
echo "Done! Verify with:"
echo "  rg --version && bat --version && fd --version && zoxide --version && delta --version"
