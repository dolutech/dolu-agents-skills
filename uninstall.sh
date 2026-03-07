#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

OPENCODE_DIR="$HOME/.config/opencode"
USER_JSON="$OPENCODE_DIR/opencode.json"

AGENTS=(orchestrator backend-engineer frontend-dev api-specialist security-analyst code-review debugger test-runner documentation-writer researcher)
SKILLS=(brainstorming executing-plans writing-plans requesting-code-review receiving-code-review skill-creator stripe-best-practices systematic-debugging frontend-design verification-before-completion)
MCPS=(chrome-devtools playwright memory fetch)

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║   🗑️  Dolu Agents & Skills - Uninstaller         ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
read -p "Are you sure you want to remove all Dolu agents and skills? [y/N]: " confirm

if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Backup
if [ -f "$USER_JSON" ]; then
    cp "$USER_JSON" "$USER_JSON.bkp.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}↳ Backup saved before uninstall${NC}"
fi

# Remove agent .md files
echo ""
for agent in "${AGENTS[@]}"; do
    if [ -f "$OPENCODE_DIR/agent/$agent.md" ]; then
        rm -f "$OPENCODE_DIR/agent/$agent.md"
        echo -e "  ${GREEN}✓${NC} Removed agent: $agent"
    fi
done

# Remove skill folders
echo ""
for skill in "${SKILLS[@]}"; do
    if [ -d "$OPENCODE_DIR/skills/$skill" ]; then
        rm -rf "$OPENCODE_DIR/skills/$skill"
        echo -e "  ${GREEN}✓${NC} Removed skill: $skill"
    fi
done

# Remove entries from opencode.json
if command -v jq &> /dev/null && [ -f "$USER_JSON" ]; then
    echo ""
    echo "Cleaning opencode.json..."

    AGENT_FILTER=$(printf 'del(.agent."%s") | ' "${AGENTS[@]}")
    MCP_FILTER=$(printf 'del(.mcpServers."%s") | ' "${MCPS[@]}")
    FILTER="${AGENT_FILTER}${MCP_FILTER} ."

    jq "$FILTER" "$USER_JSON" > "$USER_JSON.tmp" && mv "$USER_JSON.tmp" "$USER_JSON"
    echo -e "${GREEN}✓ opencode.json cleaned (only Dolu entries removed)${NC}"
fi

# Remove GUIDELINES.md
rm -f "$OPENCODE_DIR/GUIDELINES.md"

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo -e "║  ${GREEN}✓ Uninstall complete!${NC}                            ║"
echo "║  Restart OpenCode to apply changes.              ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo -e "Your API keys, providers, and other settings were ${GREEN}NOT touched${NC}."
echo ""
