# Correção da Chave MCP Servers

## Problema Identificado

Após a instalação das skills no projeto `dolu-agents-skills`, usuários relataram o seguinte erro ao iniciar o opencode:

```
Error: Configuration is invalid at /root/.config/opencode/opencode.json
↳ Unrecognized key: "mcpServers"
```

## Causa Raiz

O arquivo `opencode.agents.json` estava utilizando a chave `"mcpServers"` para configuração dos servidores MCP (Model Context Protocol), porém a versão atual do opencode (1.2.27) espera a chave `"mcp"`.

## Solução Aplicada

### 1. Arquivo `opencode.agents.json`

**Antes:**
```json
"mcpServers": {
  "chrome-devtools": { ... },
  "playwright": { ... },
  "memory": { ... },
  "fetch": { ... }
}
```

**Depois:**
```json
"mcp": {
  "chrome-devtools": { ... },
  "playwright": { ... },
  "memory": { ... },
  "fetch": { ... }
}
```

### 2. Script `install.sh`

**Antes:**
```bash
jq -s '
  .[0] as $user |
  .[1] as $pack |
  $user * {
    "agent": (($user.agent // {}) * $pack.agent),
    "mcpServers": (($user.mcpServers // {}) * $pack.mcpServers)
  }
' "$USER_JSON" "$PACK_JSON" > "$USER_JSON.tmp"
```

**Depois:**
```bash
jq -s '
  .[0] as $user |
  .[1] as $pack |
  $user * {
    "agent": (($user.agent // {}) * $pack.agent),
    "mcp": (($user.mcp // {}) * $pack.mcp)
  }
' "$USER_JSON" "$PACK_JSON" > "$USER_JSON.tmp"
```

## Correção para Instalações Existentes

Se você já instalou as skills e está enfrentando este erro, execute o seguinte comando:

```bash
sed -i 's/"mcpServers"/"mcp"/g' ~/.config/opencode/opencode.json
```

Em seguida, reinicie o opencode:

```bash
opencode
```

## Arquivos Modificados

- `opencode.agents.json` - Template de configuração do pacote
- `install.sh` - Script de instalação

## Versão do OpenCode

Esta correção foi testada e validada para a versão **1.2.27** do opencode.

## Prevenção Futura

Para evitar este tipo de problema em futuras atualizações:

1. Sempre verificar a documentação oficial do opencode para mudanças no schema de configuração
2. Testar o instalador em um ambiente limpo antes de liberar novas versões
3. Manter um changelog das mudanças no formato de configuração

## Referências

- Documentação oficial: https://opencode.ai/docs
- Repositório: https://github.com/dolutech/dolu-agents-skills
