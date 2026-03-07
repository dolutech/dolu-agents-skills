# OpenCode Security & Development Guidelines

## Core Principles

- **Security First:** Defense in depth, zero trust, least privilege, fail-secure
- **Production Ready:** Complete code only, no placeholders or TODOs
- **Infrastructure as Code:** Everything versioned, reproducible, automated

---

## Sequential Thinking - When to Use

**USE FOR:**
- Security incident analysis and threat modeling
- Multi-step vulnerability remediation
- Complex architecture design
- Root cause analysis and debugging
- Infrastructure deployment planning
- CI/CD pipeline design

**SKIP FOR:**
- Simple queries
- Documentation lookups
- Single-step tasks

---

## MCP Tool Strategy

**Brave Search:**
- CVE research and security advisories
- Infrastructure best practices
- Attack patterns and exploits
- Compliance standards

**Context7:**
- Framework documentation
- API references
- Configuration syntax
- Security patterns

**Grep (GitHub):**
- Real-world implementations
- Infrastructure as Code patterns
- Security configurations
- CI/CD examples

**GitHub:**
- Repository operations
- Issue and PR management
- Code review automation
- CI/CD workflows

**N8N:**
- Security alert automation
- Monitoring pipelines
- Incident response workflows
- Multi-tool orchestration

---

## Code Standards

**ALWAYS:**
- Complete, production-ready implementations
- Robust error handling with specific exceptions
- Structured logging (JSON format)
- Input validation and sanitization
- Rate limiting and throttling
- Secrets in environment variables
- Type hints and strong typing
- Unit and integration tests
- Security headers and HTTPS

**NEVER:**
- Hardcoded credentials
- Unvalidated user inputs
- Generic exception handling
- Incomplete implementations
- Missing security controls

---

## Security Checklist

**Application:**
- Input validation (whitelist approach)
- Output encoding and escaping
- Authentication and authorization
- Session management (secure cookies, CSRF)
- Rate limiting and DDoS protection
- SQL injection prevention (parameterized queries)
- XSS prevention (CSP headers)
- SSRF prevention (URL validation)
- Security headers (HSTS, CSP, X-Frame-Options)

**Infrastructure:**
- TLS/SSL with automated renewal
- Firewall rules (default deny)
- Network segmentation
- Container security (non-root, minimal images)
- Kubernetes security contexts
- SSH key-based auth only
- Regular security updates
- IDS/IPS (Wazuh, CrowdSec)
- WAF (BunkerWeb, ModSecurity)
- Encrypted backups

**Access Control:**
- Role-based access control (RBAC)
- Multi-factor authentication (MFA)
- Service accounts with minimal permissions
- API key rotation
- Audit logging
- Regular access reviews

---

## Technology Stack

**Backend:** Python (FastAPI, Django), Go, Node.js  
**Databases:** PostgreSQL, Redis, MongoDB, SQLite  
**Containers:** Docker, Kubernetes, Helm  
**IaC:** Terraform, Ansible  
**Proxy:** Nginx, Traefik, HAProxy  
**Security:** Wazuh, CrowdSec, BunkerWeb, Keycloak, Vault, Trivy  
**Monitoring:** Prometheus, Grafana, Loki, Jaeger, Netdata  
**CI/CD:** GitHub Actions, GitLab CI, ArgoCD

---

## Terminal Best Practices

**Shell Scripts:**
- Use `set -euo pipefail` for safety
- Implement proper error handling
- Add logging with timestamps
- Validate inputs and dependencies

**Docker:**
- Multi-stage builds for minimal images
- Run as non-root user
- Read-only root filesystem
- Drop all capabilities, add only needed ones
- Security scanning with Trivy

**Kubernetes:**
- Apply with dry-run first
- Use security contexts
- Implement resource limits
- Enable RBAC and network policies
- Regular security audits

---

## Server Administration

**Hardening:**
- Configure firewall (UFW/iptables)
- Disable root login
- SSH key-only authentication
- Install fail2ban
- Enable automatic security updates
- Configure log rotation

**SSL/TLS:**
- Use Let's Encrypt with Certbot
- Automated certificate renewal
- Strong cipher suites
- HSTS enabled

**Monitoring:**
- System resources (CPU, RAM, disk, network)
- Application metrics
- Security events
- Error rates
- Performance metrics

---

## Workflow Patterns

**Security Incident:**
Sequential Thinking → Brave (research) → Context7 (tools) → Grep (patterns) → N8N (containment) → GitHub (documentation)

**Infrastructure Deploy:**
Sequential Thinking → Context7 (syntax) → Grep (patterns) → GitHub (code) → N8N (pipeline) → Validation

**Vulnerability Management:**
Brave (CVE research) → Sequential Thinking (assessment) → Context7 (patches) → GitHub (tracking) → N8N (deployment)

**Code Review:**
GitHub (fetch) → Sequential Thinking (analysis) → Grep (patterns) → Context7 (practices) → GitHub (review)

---

## Development Workflow

**Pre-Commit:**
- Linting passes
- Security scanning complete
- Tests passing
- Dependencies scanned
- No secrets in code
- Documentation updated

**CI/CD Pipeline:**
- Secret scanning (truffleHog)
- SAST (Semgrep)
- Container scanning (Trivy)
- Dependency check (OWASP)
- Automated tests
- Security gates

---

## Docker Security

**Dockerfile:**
- Multi-stage builds
- Minimal base images (alpine, distroless)
- Non-root user (USER directive)
- Read-only root filesystem
- Health checks
- Specific versions (no :latest)

**Runtime:**
- Read-only filesystem
- Drop all capabilities
- Security options (no-new-privileges)
- Resource limits
- Network isolation

---

## Kubernetes Security

**Pod Security:**
- Non-root user
- Read-only root filesystem
- Drop all capabilities
- Security contexts
- Resource limits
- Probes (liveness, readiness)

**Cluster Security:**
- RBAC enabled
- Network policies
- Pod security policies
- Secrets management
- Audit logging
- Regular updates

---

## Performance

**Database:**
- Query analysis (EXPLAIN)
- Proper indexing
- Connection pooling
- Regular VACUUM and ANALYZE

**Application:**
- Profiling and benchmarking
- Async operations where possible
- Caching (Redis)
- Load balancing

**Monitoring:**
- Response times
- Error rates
- Resource utilization
- Database query performance

---

## Emergency Response

**Incident Containment:**
- Isolate compromised systems
- Block attacker IPs
- Preserve evidence
- Rotate credentials
- Enable verbose logging

**Recovery:**
- Database restore from backup
- Application rollback
- Certificate renewal
- Cache clearing
- System verification

---

## Audit & Compliance

**Tools:**
- Lynis (system audit)
- Docker Bench Security
- kube-bench (Kubernetes)
- Trivy (container scanning)
- OWASP ZAP (web app)

**Logging:**
- Structured logs (JSON)
- Centralized aggregation
- Long-term retention
- Security event tracking
- Audit trails

---

**Version:** 1.0  
**Updated:** 2025-12-30  
**Maintained by:** Lucas @ Dolutech
