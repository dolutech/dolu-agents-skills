<div align="center">

# 🤖 Dolu Agents & Skills

**Coleção de agentes especialistas e skills para OpenCode AI**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-green.svg)](https://github.com/sst/opencode)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red.svg)](https://dolutech.com)

**[ Português ](README.md) | [ English ](#-english)**

---

Transforme seu OpenCode em uma equipe de especialistas virtuais

</div>

---

## 📖 Sobre o Projeto

**Dolu Agents & Skills** é uma coleção curada de **10 agentes especialistas** e **10 skills** projetadas para funcionarem com [OpenCode](https://github.com/sst/opencode), o assistente de IA para desenvolvimento de software.

Este projeto fornece especialistas virtuais para diferentes domínios do desenvolvimento de software, desde arquitetura de backend até análise de segurança, passando por debugging sistemático e documentação técnica.

### 🎯 Por que usar?

- **Especialização Real**: Cada agente é treinado com deep knowledge em seu domínio
- **Coordenação Inteligente**: O Orchestrator delega automaticamente para os especialistas certos
- **Segurança First**: Práticas de segurança integradas em todos os agentes
- **Instalação Segura**: Scripts que preservam suas configurações existentes
- **Open Source**: Licença MIT - faça o que quiser!

---

## ✨ Features

| Feature | Descrição |
|---------|-----------|
| 🤖 **10 Agentes Especialistas** | Cada um com expertise profunda em um domínio específico |
| 🛠️ **10 Skills** | Workflows e processos estruturados para tarefas complexas |
| 🔒 **Foco em Segurança** | Práticas de segurança integradas em todos os agentes |
| 📦 **Instalação Fácil** | Script de instalação com merge seguro (preserva suas configs) |
| 🗑️ **Desinstalação Limpa** | Remove todos os arquivos sem afetar configurações existentes |
| 🔗 **MCP Servers** | Integração com Chrome DevTools, Playwright, Memory e Fetch |
| 📚 **Bem Documentado** | Cada agente e skill com instruções detalhadas |

---

## 🤖 Agentes Disponíveis

| Agente | Especialidade | Melhor Para |
|-------|--------------|-------------|
| **orchestrator** 🎯 | Coordenação | Tarefas complexas que precisam de múltiplos especialistas |
| **backend-engineer** ⚙️ | Backend | APIs, databases, microservices, sistemas distribuídos |
| **frontend-dev** 🎨 | Frontend | Web apps, performance, accessibility, UX |
| **api-specialist** 🔌 | APIs | REST, GraphQL, gRPC, API-first design |
| **security-analyst** 🔐 | Segurança | Pentesting, vulnerabilidades, attack vectors |
| **code-review** 👀 | Qualidade | Code review focado em segurança e boas práticas |
| **debugger** 🐛 | Debugging | Root cause analysis, logs, stack traces, profiling |
| **test-runner** 🧪 | Testes | Automated testing: criação, execução e gerenciamento |
| **documentation-writer** 📝 | Documentação | Technical writer: documentação clara e manutenível |
| **researcher** 🔍 | Pesquisa | Web researcher: busca, navegação, extração de conteúdo |

### Como Escolher o Agente Certo

```
Tarefa Complexa?              → orchestrator (ele delega)
API ou Backend?               → backend-engineer
UI/Frontend?                  → frontend-dev
Segurança ou Vulnerabilidades?→ security-analyst
Bug ou Erro?                  → debugger
Testes?                       → test-runner
Documentação?                 → documentation-writer
Code Review?                  → code-review
Design de API?                → api-specialist
Pesquisa na Web?              → researcher
```

---

## 🛠️ Skills Disponíveis

| Skill | Quando Usar |
|-------|-------------|
| **brainstorming** 💡 | **ANTES** de qualquer trabalho criativo - explorar requisitos e design |
| **writing-plans** 📋 | Quando tem specs/requirements para tarefas multi-step |
| **executing-plans** ▶️ | Quando tem um plano escrito para executar em sessão separada |
| **requesting-code-review** 🔍 | Quando completa tarefas, implementa features, ou antes de merge |
| **receiving-code-review** 📥 | Quando recebe feedback de code review |
| **verification-before-completion** ✅ | **ANTES** de claimar que trabalho está completo |
| **systematic-debugging** 🔧 | Quando encontra bugs, test failures, ou comportamento inesperado |
| **frontend-design** 🎨 | Para criar interfaces frontend de alta qualidade |
| **skill-creator** 🛠️ | Quando quer criar ou atualizar skills |
| **stripe-best-practices** 💳 | Para integrações com Stripe |

### Fluxo Recomendado de Skills

```
Nova Feature:
  brainstorming → writing-plans → executing-plans → verification-before-completion

Bug Fix:
  systematic-debugging → [implementar fix] → verification-before-completion

Code Review:
  requesting-code-review → [receber feedback] → receiving-code-review

Frontend:
  frontend-design → [implementar] → verification-before-completion
```

---

## 📋 Pré-requisitos

- [OpenCode](https://github.com/sst/opencode) instalado
- [jq](https://stedolan.github.io/jq/) (para instalação segura com merge)

### Instalar jq

```bash
# Ubuntu/Debian
sudo apt install jq

# Fedora
sudo dnf install jq

# Arch Linux
sudo pacman -S jq

# macOS
brew install jq

# Windows (com Chocolatey)
choco install jq
```

---

## 🚀 Instalação

### Método Rápido (Recomendado)

```bash
# Clone o repositório
git clone https://github.com/dolutech/dolu-agents-skills.git
cd dolu-agents-skills

# Execute o instalador
chmod +x install.sh
./install.sh
```

### Instalação Manual

```bash
# Criar diretórios
mkdir -p ~/.config/opencode/agent
mkdir -p ~/.config/opencode/skills

# Copiar agentes
cp agents/*.md ~/.config/opencode/agent/

# Copiar skills
cp -r skills/* ~/.config/opencode/skills/

# Copiar GUIDELINES
cp GUIDELINES.md ~/.config/opencode/

# Merge da configuração (requer jq)
jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json opencode.agents.json > /tmp/merged.json
mv /tmp/merged.json ~/.config/opencode/opencode.json
```

### Opções de Instalação

O script `install.sh` oferece 4 opções:

| Opção | Descrição |
|-------|-----------|
| **1) Everything** | Instala agentes + skills + MCPs (recomendado) |
| **2) Agents + MCPs only** | Apenas agentes e MCPs |
| **3) Skills only** | Apenas skills |
| **4) Choose individually** | Escolher cada componente individualmente |

### Segurança da Instalação

✅ O script de instalação:
- Preserva suas configurações existentes (API keys, providers, models)
- Faz backup automático antes de modificar
- Faz merge seguro (não sobrescreve agentes existentes com mesmo nome)
- Só adiciona, nunca remove

---

## 🗑️ Desinstalação

```bash
./uninstall.sh
```

O script de desinstalação:
- ✅ Remove todos os agentes do Dolu
- ✅ Remove todas as skills do Dolu
- ✅ Limpa entradas no `opencode.json`
- ✅ **PRESERVA** suas configurações existentes (API keys, providers, etc.)
- ✅ Cria backup antes de modificar

---

## 📁 Estrutura do Projeto

```
dolu-agents-skills/
├── 📁 agents/                    # Definições dos agentes especialistas
│   ├── orchestrator.md          # Coordenador de tarefas complexas
│   ├── backend-engineer.md      # Especialista em backend
│   ├── frontend-dev.md          # Especialista em frontend
│   ├── api-specialist.md        # Arquiteto de APIs
│   ├── security-analyst.md      # Analista de segurança ofensiva
│   ├── code-review.md           # Revisor de código
│   ├── debugger.md              # Especialista em debugging
│   ├── test-runner.md           # Especialista em testes
│   ├── documentation-writer.md  # Escritor técnico
│   └── researcher.md            # Pesquisador web
│
├── 📁 skills/                    # Skills especializadas
│   ├── brainstorming/           # Exploração de ideias
│   ├── executing-plans/         # Execução de planos
│   ├── writing-plans/           # Criação de planos
│   ├── requesting-code-review/  # Solicitar code review
│   ├── receiving-code-review/   # Receber code review
│   ├── skill-creator/           # Criador de skills
│   ├── stripe-best-practices/   # Integrações Stripe
│   ├── systematic-debugging/    # Debugging sistemático
│   ├── frontend-design/         # Design de interfaces
│   └── verification-before-completion/  # Verificação pré-entrega
│
├── 📄 opencode.agents.json       # Configuração dos agentes e MCPs
├── 📄 AGENTS.md                  # Regras operacionais para IA
├── 📄 GUIDELINES.md              # Diretrizes de segurança e desenvolvimento
├── 🔧 install.sh                 # Script de instalação
├── 🔧 uninstall.sh               # Script de desinstalação
├── 📖 README.md                  # Este arquivo
├── 📖 CONTRIBUTING.md            # Guia de contribuição
└── ⚖️ LICENSE                    # Licença MIT
```

---

## 💡 Exemplos de Uso

### Exemplo 1: Usando o Orchestrator para Feature Completa

```
Você: "Preciso implementar um sistema de notificações push"

Orchestrator vai:
1. 📋 Analisar requisitos e criar plano
2. ⚙️ Delegar para backend-engineer (API + Background Jobs)
3. 🎨 Delegar para frontend-dev (UI de preferências)
4. 🔐 Delegar para security-analyst (revisão de segurança)
5. 🧪 Coordenar testes com test-runner
6. 📝 Documentar com documentation-writer
7. ✅ Verificar qualidade com code-review
```

### Exemplo 2: Usando o Security Analyst

```
Você: "Analise este código em busca de vulnerabilidades"

Security Analyst vai:
1. 🔍 Mapear superfície de ataque
2. 🎯 Identificar vulnerabilidades (OWASP Top 10)
3. 💣 Desenvolver provas de conceito
4. 📊 Calcular CVSS scores
5. 🛡️ Fornecer remediação completa com código seguro
```

### Exemplo 3: Usando Systematic Debugging Skill

```
Você: "Os testes estão falhando aleatoriamente"

Skill vai:
1. 📖 Ler mensagens de erro completamente
2. 🔄 Reproduzir consistentemente
3. 🔎 Verificar mudanças recentes
4. 📊 Coletar evidências em cada camada
5. 🔍 Rastrear fluxo de dados
6. ✅ Identificar causa raiz ANTES de propor fix
```

### Exemplo 4: Fluxo Completo de Feature

```
Você: "Quero adicionar autenticação OAuth2"

1. 💡 brainstorming skill
   → Explora requisitos, opções, design
   
2. 📋 writing-plans skill
   → Cria plano detalhado de implementação
   
3. ▶️ executing-plans skill (ou orchestrator)
   → Executa plano task por task
   
4. 🔍 requesting-code-review skill
   → Solicita review do código
   
5. 📥 receiving-code-review skill
   → Processa feedback do review
   
6. ✅ verification-before-completion skill
   → Verifica tudo antes de claimar completo
```

---

## 🔒 Segurança

Este projeto foi desenvolvido com **segurança em primeiro lugar**:

### Nos Agentes
- ✅ Todos seguem práticas de segurança OWASP
- ✅ `security-analyst` usa mindset de red team
- ✅ Validação de input em todos os exemplos
- ✅ Proteção contra injection em todos os patterns

### Nos Skills
- ✅ `systematic-debugging` encontra causa raiz antes de fixes
- ✅ `verification-before-completion` garante qualidade
- ✅ `brainstorming` considera implicações de segurança

### Documentação
- ✅ `GUIDELINES.md` com diretrizes abrangentes
- ✅ `AGENTS.md` com checklists de segurança
- ✅ Exemplos de código sempre mostram versão segura

---

## 🔗 MCP Servers Configurados

| MCP Server | Status | Descrição |
|------------|--------|-----------|
| **chrome-devtools** | ✅ Habilitado | Controle do Chrome para debugging e testing |
| **playwright** | ⚪ Opcional | Automação de browser para testes E2E |
| **memory** | ✅ Habilitado | Memória persistente entre sessões |
| **fetch** | ⚪ Opcional | Fetch de URLs para pesquisa |

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor, leia [CONTRIBUTING.md](CONTRIBUTING.md) para detalhes.

### Formas de Contribuir

- 🐛 Reportar bugs
- 💡 Sugerir novas features
- 🤖 Adicionar novos agentes
- 🛠️ Criar novas skills
- 📚 Melhorar documentação
- 🌍 Traduzir para outros idiomas

### Quick Start para Contribuidores

```bash
# Fork e clone
git clone https://github.com/seu-usuario/dolu-agents-skills.git

# Crie uma branch
git checkout -b feature/minha-feature

# Faça suas mudanças
# ...

# Commit seguindo Conventional Commits
git commit -m "feat: adiciona novo agente xyz"

# Push e PR
git push origin feature/minha-feature
```

---

## 📈 Roadmap

### v1.1 (Planejado)
- [ ] Adicionar mais skills especializadas
- [ ] Suporte a múltiplos idiomas
- [ ] Templates de projetos

### v1.2 (Futuro)
- [ ] Agentes para DevOps
- [ ] Skills para cloud providers (AWS, GCP, Azure)
- [ ] Integração com mais MCPs

---

## 📄 Licença

Este projeto está licenciado sob a licença **MIT**.

**Em resumo:** Você pode fazer o que quiser com este código! 🎉

- ✅ Uso comercial
- ✅ Modificação
- ✅ Distribuição
- ✅ Uso privado

Veja o arquivo [LICENSE](LICENSE) para detalhes completos.

---

## 🙏 Créditos e Agradecimentos

### Autor
**Lucas Catão de Moraes** - [Dolutech](https://dolutech.com)

### Atribuições

Algumas skills foram adaptadas e/ou inspiradas em projetos open source:

| Skill | Fonte | Licença |
|-------|-------|---------|
| `systematic-debugging` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `verification-before-completion` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `requesting-code-review` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `receiving-code-review` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `brainstorming` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `writing-plans` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `executing-plans` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `skill-creator` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `stripe-best-practices` | [Stripe Documentation](https://stripe.com/docs/guides) | Stripe |

### Inspirado por
- [OpenCode](https://github.com/sst/opencode) - O melhor CLI de IA para desenvolvimento
- [Claude](https://claude.ai) - IA que realmente entende código
- Melhores práticas de desenvolvimento de software e segurança

### Agradecimentos
- Comunidade OpenCode
- Todos os contribuidores
- Você, por usar este projeto! ❤️

---

## 📞 Contato e Suporte

- **Issues**: [GitHub Issues](https://github.com/dolutech/dolu-agents-skills/issues)
- **Discussões**: [GitHub Discussions](https://github.com/dolutech/dolu-agents-skills/discussions)
- **Autor**: Lucas Catão de Moraes

---

<div align="center">

### ⭐ Se este projeto foi útil, considere dar uma estrela! ⭐

**[⬆ Voltar ao topo](#-dolu-agents--skills)**

---

Made with ❤️ by **Lucas Catão de Moraes** | [Dolutech](https://dolutech.com)

</div>

---

## 🇺🇸 English Version

<div align="center">

# 🤖 Dolu Agents & Skills

**Collection of specialist agents and skills for OpenCode AI**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![OpenCode Compatible](https://img.shields.io/badge/OpenCode-Compatible-green.svg)](https://github.com/sst/opencode)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red.svg)](https://dolutech.com)

Transform your OpenCode into a team of virtual specialists

</div>

---

## 📖 About

**Dolu Agents & Skills** is a curated collection of **10 specialist agents** and **10 skills** designed to work with [OpenCode](https://github.com/sst/opencode), the AI assistant for software development.

This project provides virtual specialists for different software development domains, from backend architecture to security analysis, through systematic debugging and technical documentation.

### 🎯 Why Use?

- **Real Specialization**: Each agent is trained with deep knowledge in their domain
- **Smart Coordination**: The Orchestrator automatically delegates to the right specialists
- **Security First**: Security practices integrated in all agents
- **Safe Installation**: Scripts that preserve your existing configurations
- **Open Source**: MIT License - do whatever you want!

---

## ✨ Features

| Feature | Description |
|---------|-----------|
| 🤖 **10 Specialist Agents** | Each with deep expertise in a specific domain |
| 🛠️ **10 Skills** | Structured workflows and processes for complex tasks |
| 🔒 **Security Focus** | Security practices integrated in all agents |
| 📦 **Easy Installation** | Installation script with safe merge (preserves your configs) |
| 🗑️ **Clean Uninstall** | Removes all files without affecting existing settings |
| 🔗 **MCP Servers** | Integration with Chrome DevTools, Playwright, Memory and Fetch |
| 📚 **Well Documented** | Each agent and skill with detailed instructions |

---

## 🤖 Available Agents

| Agent | Specialty | Best For |
|-------|-----------|----------|
| **orchestrator** 🎯 | Coordination | Complex tasks requiring multiple specialists |
| **backend-engineer** ⚙️ | Backend | APIs, databases, microservices, distributed systems |
| **frontend-dev** 🎨 | Frontend | Web apps, performance, accessibility, UX |
| **api-specialist** 🔌 | APIs | REST, GraphQL, gRPC, API-first design |
| **security-analyst** 🔐 | Security | Pentesting, vulnerabilities, attack vectors |
| **code-review** 👀 | Quality | Code review focused on security and best practices |
| **debugger** 🐛 | Debugging | Root cause analysis, logs, stack traces, profiling |
| **test-runner** 🧪 | Testing | Automated testing: creation, execution, management |
| **documentation-writer** 📝 | Documentation | Technical writer: clear, maintainable documentation |
| **researcher** 🔍 | Research | Web researcher: search, navigation, content extraction |

### How to Choose the Right Agent

```
Complex Task?              → orchestrator (it delegates)
API or Backend?            → backend-engineer
UI/Frontend?               → frontend-dev
Security or Vulnerabilities? → security-analyst
Bug or Error?              → debugger
Testing?                   → test-runner
Documentation?             → documentation-writer
Code Review?               → code-review
API Design?                → api-specialist
Web Research?              → researcher
```

---

## 🛠️ Available Skills

| Skill | When to Use |
|-------|-------------|
| **brainstorming** 💡 | **BEFORE** any creative work - explore requirements and design |
| **writing-plans** 📋 | When you have specs/requirements for multi-step tasks |
| **executing-plans** ▶️ | When you have a written plan to execute in separate session |
| **requesting-code-review** 🔍 | When completing tasks, implementing features, or before merge |
| **receiving-code-review** 📥 | When receiving code review feedback |
| **verification-before-completion** ✅ | **BEFORE** claiming work is complete |
| **systematic-debugging** 🔧 | When encountering bugs, test failures, or unexpected behavior |
| **frontend-design** 🎨 | For creating high-quality frontend interfaces |
| **skill-creator** 🛠️ | When you want to create or update skills |
| **stripe-best-practices** 💳 | For Stripe integrations |

### Recommended Skills Flow

```
New Feature:
  brainstorming → writing-plans → executing-plans → verification-before-completion

Bug Fix:
  systematic-debugging → [implement fix] → verification-before-completion

Code Review:
  requesting-code-review → [receive feedback] → receiving-code-review

Frontend:
  frontend-design → [implement] → verification-before-completion
```

---

## 📋 Prerequisites

- [OpenCode](https://github.com/sst/opencode) installed
- [jq](https://stedolan.github.io/jq/) (for safe installation with merge)

### Install jq

```bash
# Ubuntu/Debian
sudo apt install jq

# Fedora
sudo dnf install jq

# Arch Linux
sudo pacman -S jq

# macOS
brew install jq

# Windows (with Chocolatey)
choco install jq
```

---

## 🚀 Installation

### Quick Method (Recommended)

```bash
# Clone the repository
git clone https://github.com/dolutech/dolu-agents-skills.git
cd dolu-agents-skills

# Run the installer
chmod +x install.sh
./install.sh
```

### Manual Installation

```bash
# Create directories
mkdir -p ~/.config/opencode/agent
mkdir -p ~/.config/opencode/skills

# Copy agents
cp agents/*.md ~/.config/opencode/agent/

# Copy skills
cp -r skills/* ~/.config/opencode/skills/

# Copy GUIDELINES
cp GUIDELINES.md ~/.config/opencode/

# Merge configuration (requires jq)
jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json opencode.agents.json > /tmp/merged.json
mv /tmp/merged.json ~/.config/opencode/opencode.json
```

### Installation Options

The `install.sh` script offers 4 options:

| Option | Description |
|--------|-------------|
| **1) Everything** | Installs agents + skills + MCPs (recommended) |
| **2) Agents + MCPs only** | Only agents and MCPs |
| **3) Skills only** | Only skills |
| **4) Choose individually** | Choose each component individually |

### Installation Safety

✅ The installation script:
- Preserves your existing settings (API keys, providers, models)
- Creates automatic backup before modifying
- Does safe merge (doesn't overwrite existing agents with same name)
- Only adds, never removes

---

## 🗑️ Uninstallation

```bash
./uninstall.sh
```

The uninstallation script:
- ✅ Removes all Dolu agents
- ✅ Removes all Dolu skills
- ✅ Cleans entries from `opencode.json`
- ✅ **PRESERVES** your existing settings (API keys, providers, etc.)
- ✅ Creates backup before modifying

---

## 💡 Usage Examples

### Example 1: Using Orchestrator for Complete Feature

```
You: "I need to implement a push notification system"

Orchestrator will:
1. 📋 Analyze requirements and create plan
2. ⚙️ Delegate to backend-engineer (API + Background Jobs)
3. 🎨 Delegate to frontend-dev (Preferences UI)
4. 🔐 Delegate to security-analyst (security review)
5. 🧪 Coordinate tests with test-runner
6. 📝 Document with documentation-writer
7. ✅ Verify quality with code-review
```

### Example 2: Using Security Analyst

```
You: "Analyze this code for vulnerabilities"

Security Analyst will:
1. 🔍 Map attack surface
2. 🎯 Identify vulnerabilities (OWASP Top 10)
3. 💣 Develop proof-of-concept exploits
4. 📊 Calculate CVSS scores
5. 🛡️ Provide complete remediation with secure code
```

### Example 3: Using Systematic Debugging Skill

```
You: "Tests are failing randomly"

Skill will:
1. 📖 Read error messages completely
2. 🔄 Reproduce consistently
3. 🔎 Check recent changes
4. 📊 Collect evidence at each layer
5. 🔍 Trace data flow
6. ✅ Identify root cause BEFORE proposing fix
```

### Example 4: Complete Feature Flow

```
You: "I want to add OAuth2 authentication"

1. 💡 brainstorming skill
   → Explores requirements, options, design
   
2. 📋 writing-plans skill
   → Creates detailed implementation plan
   
3. ▶️ executing-plans skill (or orchestrator)
   → Executes plan task by task
   
4. 🔍 requesting-code-review skill
   → Requests code review
   
5. 📥 receiving-code-review skill
   → Processes review feedback
   
6. ✅ verification-before-completion skill
   → Verifies everything before claiming complete
```

---

## 🔗 Configured MCP Servers

| MCP Server | Status | Description |
|------------|--------|-------------|
| **chrome-devtools** | ✅ Enabled | Chrome control for debugging and testing |
| **playwright** | ⚪ Optional | Browser automation for E2E tests |
| **memory** | ✅ Enabled | Persistent memory between sessions |
| **fetch** | ⚪ Optional | URL fetching for research |

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 🤖 Add new agents
- 🛠️ Create new skills
- 📚 Improve documentation
- 🌍 Translate to other languages

### Quick Start for Contributors

```bash
# Fork and clone
git clone https://github.com/your-username/dolu-agents-skills.git

# Create a branch
git checkout -b feature/my-feature

# Make your changes
# ...

# Commit following Conventional Commits
git commit -m "feat: add new xyz agent"

# Push and PR
git push origin feature/my-feature
```

---

## 📈 Roadmap

### v1.1 (Planned)
- [ ] Add more specialized skills
- [ ] Support for multiple languages
- [ ] Project templates

### v1.2 (Future)
- [ ] DevOps agents
- [ ] Cloud provider skills (AWS, GCP, Azure)
- [ ] Integration with more MCPs

---

## 📄 License

This project is licensed under the **MIT License**.

**In short:** You can do whatever you want with this code! 🎉

- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use

See the [LICENSE](LICENSE) file for complete details.

---

## 🙏 Credits and Acknowledgments

### Author
**Lucas Catão de Moraes** - [Dolutech](https://dolutech.com)

### Attributions

Some skills were adapted and/or inspired by open source projects:

| Skill | Source | License |
|-------|--------|---------|
| `systematic-debugging` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `verification-before-completion` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `requesting-code-review` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `receiving-code-review` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `brainstorming` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `writing-plans` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `executing-plans` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `skill-creator` | [Anthropic Skills](https://github.com/anthropics/skills) | Apache 2.0 |
| `stripe-best-practices` | [Stripe Documentation](https://stripe.com/docs/guides) | Stripe |

### Inspired by
- [OpenCode](https://github.com/sst/opencode) - The best AI CLI for development
- [Claude](https://claude.ai) - AI that really understands code
- Best practices in software development and security

### Acknowledgments
- OpenCode Community
- All contributors
- You, for using this project! ❤️

---

## 📞 Contact and Support

- **Issues**: [GitHub Issues](https://github.com/dolutech/dolu-agents-skills/issues)
- **Discussions**: [GitHub Discussions](https://github.com/dolutech/dolu-agents-skills/discussions)
- **Author**: Lucas Catão de Moraes

---

<div align="center">

### ⭐ If this project was helpful, consider giving it a star! ⭐

**[⬆ Back to top](#-dolu-agents--skills)**

---

Made with ❤️ by **Lucas Catão de Moraes** | [Dolutech](https://dolutech.com)

</div>
