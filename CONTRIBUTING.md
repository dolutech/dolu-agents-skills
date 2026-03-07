# Contribuindo para Dolu Agents & Skills

🎉 Obrigado pelo interesse em contribuir! 🎉

Este projeto existe graças a contribuições da comunidade. Valorizamos cada contribuição, seja grande ou pequena.

---

## 📋 Código de Conduta

Este projeto adere ao [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Ao participar, você concorda em seguir este padrões de comportamento.

**Em resumo:**
- Seja respeitoso e inclusivo
- Valorize diferentes perspectivas
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros

---

## 🤔 Como Contribuir

### Reportando Bugs 🐛

Antes de reportar um bug, por favor:

1. **Verifique se já foi reportado** nas [Issues](https://github.com/dolutech/dolu-agents-skills/issues)
2. **Teste com a versão mais recente** do projeto
3. **Colete informações** sobre o ambiente

#### Template de Bug Report

```markdown
**Descrição do Bug**
Uma descrição clara do que está acontecendo.

**Passos para Reproduzir**
1. Execute '...'
2. Veja o erro '...'
3. O problema ocorre quando '...'

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que está acontecendo.

**Ambiente**
- OS: [e.g. Ubuntu 22.04]
- OpenCode version: [e.g. 1.0.0]
- Agent/Skill afetado: [e.g. backend-engineer]

**Screenshots/Logs**
Se aplicável, adicione screenshots ou logs relevantes.
```

---

### Sugerindo Melhorias 💡

Adoramos sugestões! Para features ou melhorias:

1. **Verifique se já foi sugerido** nas [Issues](https://github.com/dolutech/dolu-agents-skills/issues) com a label `enhancement`
2. **Abra uma issue** com a tag `enhancement`
3. **Descreva**:
   - O que você quer adicionar
   - Por que seria útil
   - Exemplos de uso (se aplicável)

---

### Adicionando Novos Agentes 🤖

#### Estrutura de um Agente

```markdown
# [Nome do Agente]

You are a senior [especialidade] specialist...

## Core Expertise

**Languages & Frameworks:**
- [lista de tecnologias]

## [Seções específicas do domínio]

## Output Format

[Exemplos de output esperado]

## Tool Usage Strategy

[Como usar ferramentas disponíveis]

## Response Style

[Diretrizes de resposta]
```

#### Checklist para Novo Agente

- [ ] Arquivo criado em `agents/nome-do-agente.md`
- [ ] Configuração adicionada em `opencode.agents.json`
- [ ] Adicionado ao array `AGENTS` em `install.sh`
- [ ] Adicionado ao array `AGENTS` em `uninstall.sh`
- [ ] Documentação atualizada no `README.md`
- [ ] Testado localmente
- [ ] Commit segue Conventional Commits

---

### Adicionando Novas Skills 🛠️

#### Estrutura de uma Skill

```markdown
---
name: nome-da-skill
description: Descrição clara de quando e como usar esta skill
---

# [Nome da Skill]

## Overview

[Descrição geral]

## When to Use

[Casos de uso específicos]

## Process

[Passos detalhados]

## Examples

[Exemplos práticos]
```

#### Checklist para Nova Skill

- [ ] Diretório criado em `skills/nome-da-skill/`
- [ ] Arquivo `SKILL.md` criado com frontmatter
- [ ] Arquivos de referência adicionados (se necessário)
- [ ] Adicionado ao array `SKILLS` em `install.sh`
- [ ] Adicionado ao array `SKILLS` em `uninstall.sh`
- [ ] Documentação atualizada no `README.md`
- [ ] Testado localmente
- [ ] Commit segue Conventional Commits

---

### Melhorando Documentação 📚

A documentação é crucial! Você pode contribuir:

- **Correções de typos** - Sempre bem-vindas
- **Clarificações** - Torne explicações mais claras
- **Traduções** - Ajude suporte a outros idiomas
- **Exemplos** - Adicione exemplos práticos
- **Badges** - Adicione badges relevantes

---

## 🔧 Desenvolvimento Local

### Setup

```bash
# Fork o repositório (via GitHub UI)

# Clone seu fork
git clone https://github.com/SEU-USUARIO/dolu-agents-skills.git
cd dolu-agents-skills

# Execute a instalação local para testar
./install.sh
```

### Testando Mudanças

```bash
# Para testar agentes
# 1. Abra o OpenCode
# 2. Use o agente que você modificou/criou
# 3. Verifique se o comportamento está correto

# Para testar skills
# 1. Invoque a skill no OpenCode
# 2. Siga o workflow
# 3. Verifique se o resultado está correto

# Para testar scripts
bash -n install.sh    # Verifica sintaxe
bash -n uninstall.sh  # Verifica sintaxe
```

---

## 📝 Padrões de Código

### Markdown
- Use markdown válido e bem formatado
- Headers hierárquicos e lógicos
- Links funcionando corretamente
- Tabelas bem formatadas

### Bash Scripts
- Use `#!/bin/bash` shebang
- Trate erros apropriadamente
- Use cores/emojis para output
- Testado em bash 4+

### JSON
- JSON válido
- Indentação consistente (2 espaços)
- Chaves ordenadas alfabeticamente (quando apropriado)

---

## 🔄 Processo de Pull Request

### 1. Prepare sua Branch

```bash
# Certifique-se de estar na main
git checkout main

# Atualize com o último código
git pull origin main

# Crie sua branch
git checkout -b feature/sua-feature
# ou
git checkout -b fix/seu-fix
# ou
git checkout -b docs/sua-documentacao
```

### 2. Faça suas Mudanças

```bash
# Edite os arquivos necessários
# Teste suas mudanças localmente
# Verifique se tudo funciona
```

### 3. Commit suas Mudanças

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Tipos de commit:
# feat: nova feature
# fix: correção de bug
# docs: documentação
# refactor: refatoração
# test: testes
# chore: manutenção

# Exemplos:
git commit -m "feat: adiciona agente data-engineer"
git commit -m "fix: corrige caminho no script de instalação"
git commit -m "docs: atualiza README com novos exemplos"
git commit -m "refactor: reorganiza estrutura do security-analyst"
```

### 4. Push e PR

```bash
# Push para seu fork
git push origin feature/sua-feature
```

Depois:
1. Vá para [o repositório original](https://github.com/dolutech/dolu-agents-skills)
2. Clique em "New Pull Request"
3. Selecione sua branch
4. Preencha o template

---

## ✅ Checklist do Pull Request

Antes de abrir um PR, verifique:

### Geral
- [ ] Código segue os padrões do projeto
- [ ] Commits seguem Conventional Commits
- [ ] Não há arquivos gerados (build, cache, etc.)

### Para Agentes
- [ ] Agente tem descrição clara
- [ ] Configuração adicionada ao JSON
- [ ] Scripts atualizados
- [ ] Documentação atualizada
- [ ] Testado localmente

### Para Skills
- [ ] SKILL.md tem frontmatter correto
- [ ] Descrição clara de quando usar
- [ ] Processo bem definido
- [ ] Exemplos incluídos
- [ ] Scripts atualizados
- [ ] Documentação atualizada

### Para Scripts
- [ ] Sintaxe bash válida (`bash -n script.sh`)
- [ ] Tratamento de erros
- [ ] Testado em diferentes cenários

### Para Documentação
- [ ] Markdown válido
- [ ] Links funcionando
- [ ] Sem typos
- [ ] Clareza e precisão

---

## 🎯 Áreas que Precisam de Ajuda

Atualmente, precisamos de ajuda com:

### Alta Prioridade
- [ ] Tradução para inglês (English README)
- [ ] Mais exemplos de uso
- [ ] Testes automatizados

### Média Prioridade
- [ ] Agentes para DevOps (devops-engineer)
- [ ] Agentes para Cloud (aws-specialist, gcp-specialist, azure-specialist)
- [ ] Skills para CI/CD

### Baixa Prioridade
- [ ] Integração com outros MCPs
- [ ] Templates de projetos
- [ ] Vídeos/tutoriais

---

## ❓ Precisa de Ajuda?

### Perguntas sobre Contribuição
- Abra uma [Issue](https://github.com/dolutech/dolu-agents-skills/issues) com a tag `question`
- Participe das [Discussions](https://github.com/dolutech/dolu-agents-skills/discussions)

### Problemas Técnicos
- Abra uma [Issue](https://github.com/dolutech/dolu-agents-skills/issues) com a tag `bug`
- Inclua logs, screenshots, e ambiente

### Sugestões
- Abra uma [Issue](https://github.com/dolutech/dolu-agents-skills/issues) com a tag `enhancement`
- Participe das [Discussions](https://github.com/dolutech/dolu-agents-skills/discussions)

---

## 🏆 Reconhecimento

Contribuidores serão reconhecidos:

- No README (seção Contributors)
- No changelog (quando implementarmos)
- Em releases notes

Contribuições significativas podem ganhar:
- Status de Collaborator
- Acesso antecipado a novos agentes/skills
- Swag do Dolutech 😎

---

## 📜 Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a [MIT License](LICENSE).

---

<div align="center">

### 🎉 Obrigado por contribuir! 🎉

**Juntos, estamos construindo algo incrível para a comunidade de desenvolvedores!**

[⬆ Voltar ao README](README.md)

</div>
