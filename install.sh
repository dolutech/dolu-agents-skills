#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

OPENCODE_DIR="$HOME/.config/opencode"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACK_JSON="$SCRIPT_DIR/opencode.agents.json"
USER_JSON="$OPENCODE_DIR/opencode.json"

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║   🤖 Dolu Agents & Skills - Installer            ║${NC}"
echo -e "${BOLD}║   github.com/dolutech/dolu-agents-skills          ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── Check jq ──
if ! command -v jq &> /dev/null; then
    echo -e "${RED}✗ 'jq' is required for safe JSON merging${NC}"
    echo ""
    echo "  Install it with:"
    echo "    Ubuntu/Debian:  sudo apt install jq"
    echo "    Fedora:         sudo dnf install jq"
    echo "    Arch:           sudo pacman -S jq"
    echo "    macOS:          brew install jq"
    exit 1
fi

# ── Create directories ──
mkdir -p "$OPENCODE_DIR/agent"
mkdir -p "$OPENCODE_DIR/skills"

# ── Menu ──
echo "What would you like to install?"
echo ""
echo "  1) Everything (agents + skills + required MCPs)"
echo "  2) Agents + MCPs only"
echo "  3) Skills only"
echo "  4) Choose individually"
echo ""
read -p "Option [1-4]: " OPCAO

# ══════════════════════════════════════
# Function: safe merge into opencode.json
# Adds without overwriting existing config
# ══════════════════════════════════════
merge_json() {
    if [ ! -f "$USER_JSON" ]; then
        cp "$PACK_JSON" "$USER_JSON"
        echo -e "${GREEN}✓ opencode.json created${NC}"
        return
    fi

    BACKUP="$USER_JSON.bkp.$(date +%Y%m%d_%H%M%S)"
    cp "$USER_JSON" "$BACKUP"
    echo -e "${YELLOW}↳ Backup saved: $(basename $BACKUP)${NC}"

    # Deep merge:
    # - agent:      ADDS new agents, does NOT overwrite existing ones with the same name
    # - mcpServers: ADDS new MCPs, does NOT overwrite existing ones with the same name
    # - Everything else: UNTOUCHED (apiKeys, provider, model, etc.)
    jq -s '
      .[0] as $user |
      .[1] as $pack |
      $user * {
        "agent": (($user.agent // {}) * $pack.agent),
        "mcpServers": (($user.mcpServers // {}) * $pack.mcpServers)
      }
    ' "$USER_JSON" "$PACK_JSON" > "$USER_JSON.tmp"

    if [ $? -eq 0 ] && [ -s "$USER_JSON.tmp" ]; then
        mv "$USER_JSON.tmp" "$USER_JSON"
        echo -e "${GREEN}✓ opencode.json updated (safe merge)${NC}"
    else
        rm -f "$USER_JSON.tmp"
        echo -e "${RED}✗ Merge failed. Backup preserved: $(basename $BACKUP)${NC}"
        cp "$BACKUP" "$USER_JSON"
    fi
}

# ══════════════════════
# Install agents
# ══════════════════════
install_agents() {
    echo ""
    echo -e "${BLUE}── Installing agents ──${NC}"
    cp "$SCRIPT_DIR"/agents/*.md "$OPENCODE_DIR/agent/"

    if [ -f "$SCRIPT_DIR/GUIDELINES.md" ]; then
        cp "$SCRIPT_DIR/GUIDELINES.md" "$OPENCODE_DIR/GUIDELINES.md"
    fi

    echo -e "${GREEN}✓ 10 agents copied to ~/.config/opencode/agent/${NC}"
    echo ""
    echo -e "${BLUE}── Updating opencode.json ──${NC}"
    merge_json
}

# ══════════════════════
# Install skills
# ══════════════════════
install_skills() {
    echo ""
    echo -e "${BLUE}── Installing skills ──${NC}"
    cp -r "$SCRIPT_DIR"/skills/* "$OPENCODE_DIR/skills/"
    echo -e "${GREEN}✓ 10 skills copied to ~/.config/opencode/skills/${NC}"
}

# ══════════════════════════
# Individual installation
# ══════════════════════════
install_individual() {
    echo ""
    echo -e "${BLUE}── Available agents ──${NC}"
    for f in "$SCRIPT_DIR"/agents/*.md; do
        name=$(basename "$f" .md)
        read -p "  Install $name? [y/N]: " resp
        if [[ "$resp" =~ ^[yY]$ ]]; then
            cp "$f" "$OPENCODE_DIR/agent/"
            echo -e "    ${GREEN}✓ $name${NC}"
        fi
    done

    echo ""
    echo -e "${BLUE}── Available skills ──${NC}"
    for d in "$SCRIPT_DIR"/skills/*/; do
        name=$(basename "$d")
        read -p "  Install $name? [y/N]: " resp
        if [[ "$resp" =~ ^[yY]$ ]]; then
            cp -r "$d" "$OPENCODE_DIR/skills/"
            echo -e "    ${GREEN}✓ $name${NC}"
        fi
    done

    echo ""
    echo -e "${BLUE}── Updating opencode.json ──${NC}"
    merge_json
}

# ══════════════════════
# Run
# ══════════════════════
case $OPCAO in
    1)
        install_agents
        install_skills
        ;;
    2)
        install_agents
        ;;
    3)
        install_skills
        ;;
    4)
        install_individual
        ;;
    *)
        echo -e "${RED}Invalid option${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║  ${GREEN}✓ Installation complete!${NC}${BOLD}                        ║${NC}"
echo -e "${BOLD}║  Restart OpenCode to apply changes.              ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Your original data (API keys, providers, models) was ${GREEN}NOT modified${NC}."
echo -e "A backup was saved at: ${YELLOW}~/.config/opencode/opencode.json.bkp.*${NC}"
echo ""
