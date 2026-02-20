#!/bin/bash
# plannotator - Installation Script
# Installs the plannotator CLI and optionally the Claude Code plugin
#
# Usage:
#   ./install.sh              # CLI only
#   ./install.sh --with-plugin # CLI + Claude Code plugin

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

WITH_PLUGIN=false
for arg in "$@"; do
  case $arg in
    --with-plugin) WITH_PLUGIN=true ;;
    -h|--help)
      echo "Usage: $0 [--with-plugin]"
      echo ""
      echo "Options:"
      echo "  --with-plugin   Also output Claude Code plugin install commands"
      echo "  -h, --help      Show this help"
      exit 0
      ;;
  esac
done

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       plannotator Installer                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

# Detect OS
OS=""
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      OS="wsl"
    else
      OS="linux"
    fi
    ;;
  CYGWIN*|MINGW*|MSYS*) OS="windows" ;;
  *) OS="unknown" ;;
esac

echo -e "${BLUE}Detected OS:${NC} ${OS}"
echo ""

# Check if already installed
if command -v plannotator &>/dev/null; then
  CURRENT_VERSION=$(plannotator --version 2>/dev/null || echo "unknown")
  echo -e "${YELLOW}plannotator is already installed (version: ${CURRENT_VERSION})${NC}"
  echo -e "${GRAY}Re-running install to update to latest version...${NC}"
  echo ""
fi

# Install CLI
echo -e "${BLUE}Installing plannotator CLI...${NC}"

case "$OS" in
  macos|linux|wsl)
    if curl -fsSL https://plannotator.ai/install.sh | bash; then
      echo ""
      echo -e "${GREEN}✓ plannotator CLI installed successfully${NC}"
    else
      echo -e "${RED}✗ Installation failed${NC}"
      echo -e "${YELLOW}Try manual install: curl -fsSL https://plannotator.ai/install.sh | bash${NC}"
      exit 1
    fi
    ;;
  windows)
    echo -e "${YELLOW}Windows detected. Run in PowerShell:${NC}"
    echo ""
    echo "    irm https://plannotator.ai/install.ps1 | iex"
    echo ""
    echo -e "${GRAY}Or for CMD:${NC}"
    echo "    curl -fsSL https://plannotator.ai/install.cmd -o install.cmd && install.cmd && del install.cmd"
    echo ""
    exit 0
    ;;
  *)
    echo -e "${RED}Unsupported OS. Visit https://plannotator.ai for manual install instructions.${NC}"
    exit 1
    ;;
esac

# Verify installation
echo ""
echo -e "${BLUE}Verifying installation...${NC}"

# Reload PATH in case plannotator was added to a new location
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if command -v plannotator &>/dev/null; then
  VERSION=$(plannotator --version 2>/dev/null || echo "unknown")
  echo -e "${GREEN}✓ plannotator ${VERSION} is ready${NC}"
  echo -e "${GRAY}  Location: $(which plannotator)${NC}"
else
  echo -e "${YELLOW}⚠ plannotator installed but not in PATH${NC}"
  echo -e "${YELLOW}  Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)${NC}"
fi

# Claude Code plugin instructions
if [ "$WITH_PLUGIN" = true ]; then
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}Claude Code Plugin Setup${NC}"
  echo ""
  echo -e "Run these commands inside Claude Code:"
  echo ""
  echo -e "  ${GREEN}/plugin marketplace add backnotprop/plannotator${NC}"
  echo -e "  ${GREEN}/plugin install plannotator@plannotator${NC}"
  echo ""
  echo -e "${YELLOW}⚠ IMPORTANT: Restart Claude Code after plugin install${NC}"
  echo ""
  echo -e "${GRAY}Alternative (manual hook): run ./setup-hook.sh${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GRAY}Next steps:${NC}"
echo -e "  ${BLUE}1.${NC} Run ${GREEN}./setup-hook.sh${NC} to configure Claude Code hooks (if not using plugin)"
echo -e "  ${BLUE}2.${NC} Run ${GREEN}./check-status.sh${NC} to verify everything is working"
echo ""
