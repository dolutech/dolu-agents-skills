# DevOps Agents & Skills Documentation

## Overview

This document provides comprehensive documentation for the three new DevOps specialist agents and their associated skills added to the Dolu Agents & Skills collection.

## New Agents

### 1. Deploy Specialist Agent (`deploy-specialist`)

**Description:** DevOps engineer specializing in deployment automation, CI/CD pipelines, and production releases.

**Expertise:**
- **Deployment Platforms:** Kubernetes, Docker, AWS, GCP, Azure, PaaS
- **CI/CD Systems:** GitHub Actions, GitLab CI, Jenkins, CircleCI, ArgoCD
- **Deployment Strategies:** Rolling, Blue-Green, Canary, Feature Flags
- **Infrastructure as Code:** Terraform, Ansible, Pulumi, CloudFormation

**Best For:**
- Setting up CI/CD pipelines from scratch
- Implementing zero-downtime deployments
- Managing multi-environment deployments
- Creating rollback procedures
- Automating database migrations
- GitOps implementations

**Example Usage:**
```
"Set up a CI/CD pipeline for my Node.js application with GitHub Actions"
"Help me implement blue-green deployment on Kubernetes"
"Create a canary deployment strategy with automatic rollback"
"Design a GitOps workflow with ArgoCD"
```

**Associated Skill:** `deploy-automation`

---

### 2. Web Server Setup Specialist (`web-server-setup`)

**Description:** Web server engineer specializing in setup, configuration, and optimization of web servers.

**Expertise:**
- **Web Servers:** Nginx, Apache, Traefik, Caddy, HAProxy
- **SSL/TLS:** Let's Encrypt, certificate management, TLS configuration
- **Load Balancing:** Round-robin, least connections, sticky sessions
- **Performance:** HTTP/2, HTTP/3, compression, caching, CDN
- **Security:** WAF, DDoS protection, rate limiting, security headers

**Best For:**
- Installing and configuring web servers
- Setting up SSL/TLS certificates
- Configuring reverse proxy and load balancers
- Optimizing web server performance
- Implementing security headers
- Setting up virtual hosts

**Example Usage:**
```
"Configure Nginx as a reverse proxy with SSL"
"Set up load balancing across 3 backend servers"
"Configure automatic SSL certificates with Let's Encrypt"
"Optimize Nginx for high-traffic applications"
"Set up Traefik with Docker and automatic HTTPS"
```

**Associated Skill:** `webserver-configuration`

---

### 3. Server Management Specialist (`server-management`)

**Description:** System administrator specializing in Linux server management, security hardening, and maintenance.

**Expertise:**
- **Operating Systems:** Ubuntu, Debian, CentOS, RHEL, Rocky Linux
- **Security Hardening:** CIS Benchmarks, firewall, SSH hardening, audit logging
- **Monitoring:** Prometheus, Grafana, Netdata, ELK Stack, Loki
- **Backup & Recovery:** rsync, BorgBackup, Restic, disaster recovery
- **Performance:** CPU/memory tuning, disk I/O, network optimization

**Best For:**
- Hardening new servers for production
- Implementing security baselines
- Setting up monitoring and alerting
- Creating backup strategies
- Performance tuning
- Security incident response

**Example Usage:**
```
"Harden my Ubuntu server following CIS Benchmarks"
"Set up Prometheus and Grafana monitoring"
"Create a comprehensive backup strategy"
"Configure Fail2ban and intrusion detection"
"Optimize Linux kernel parameters for performance"
```

**Associated Skill:** `server-hardening`

---

## New Skills

### 1. Deploy Automation (`deploy-automation`)

**Purpose:** Workflows and best practices for CI/CD automation, deployment strategies, and production releases.

**When to Use:**
- Setting up CI/CD pipelines
- Implementing deployment strategies (blue-green, canary, rolling)
- Managing multiple environments
- Automating database migrations
- Planning zero-downtime deployments
- Creating rollback procedures

**Key Resources:**
- `resources/ci-cd-patterns.md`: Complete CI/CD pipeline configurations
- `resources/deployment-strategies.md`: Detailed deployment implementations

**Core Concepts:**
- Automation first
- Safety mechanisms (gates, checks)
- Reversibility (rollback capability)
- Environment management
- Feature flags

---

### 2. Server Hardening (`server-hardening`)

**Purpose:** Comprehensive server security hardening workflows based on CIS Benchmarks.

**When to Use:**
- Setting up new production servers
- Improving security posture
- Implementing CIS Benchmark compliance
- Preparing for security audits
- Responding to security incidents
- Establishing security baselines

**Key Resources:**
- `resources/cis-benchmarks.md`: Complete CIS Benchmark implementation
- `resources/security-checklist.md`: Comprehensive security checklist

**Core Concepts:**
- Defense in depth
- Principle of least privilege
- Zero trust
- Continuous monitoring
- Regular maintenance

**Hardening Phases:**
1. Pre-hardening assessment
2. Security baseline establishment
3. Hardening implementation
4. Validation
5. Ongoing maintenance

---

### 3. Web Server Configuration (`webserver-configuration`)

**Purpose:** Complete web server configuration workflows for Nginx, Apache, Traefik, and Caddy.

**When to Use:**
- Installing and configuring web servers
- Setting up SSL/TLS certificates
- Configuring reverse proxy
- Implementing load balancing
- Optimizing performance
- Adding security headers

**Key Resources:**
- `resources/nginx-configs.md`: Complete Nginx configurations
- `resources/apache-configs.md`: Complete Apache configurations
- `resources/ssl-setup.md`: SSL/TLS setup guide
- `resources/performance-tuning.md`: Performance optimization

**Core Concepts:**
- Security first (headers, TLS, access control)
- Performance optimization (caching, compression)
- High availability (load balancing, health checks)
- Monitoring and logging

---

## Integration Patterns

### Typical DevOps Workflow

```
1. Server Management Specialist
   └→ Set up and harden server
   └→ Configure monitoring
   └→ Set up backup strategy

2. Web Server Setup Specialist
   └→ Install and configure web server
   └→ Set up SSL/TLS
   └→ Configure reverse proxy

3. Deploy Specialist
   └→ Set up CI/CD pipeline
   └→ Configure deployment strategy
   └→ Implement rollback procedures
```

### Example: Complete Production Setup

**Scenario:** Deploy a Node.js application to production

1. **Server Management Specialist:**
   - Provision Ubuntu server
   - Run security hardening
   - Configure firewall (UFW)
   - Set up monitoring (Prometheus + Grafana)
   - Configure backup strategy

2. **Web Server Setup Specialist:**
   - Install Nginx
   - Configure reverse proxy
   - Set up SSL/TLS (Let's Encrypt)
   - Configure security headers
   - Set up rate limiting

3. **Deploy Specialist:**
   - Create GitHub Actions workflow
   - Implement rolling deployment
   - Configure health checks
   - Set up automatic rollback
   - Configure notifications

---

## Security Considerations

All DevOps agents follow these security principles:

1. **Secrets Management:**
   - Never hardcode credentials
   - Use secret managers (Vault, AWS Secrets Manager)
   - Rotate credentials regularly

2. **Least Privilege:**
   - Minimal permissions for services
   - Restricted user accounts
   - Isolated environments

3. **Defense in Depth:**
   - Multiple security layers
   - Firewall rules
   - Intrusion detection
   - Regular audits

4. **Monitoring & Logging:**
   - Comprehensive logging
   - Security event monitoring
   - Alerting on anomalies
   - Audit trails

---

## Best Practices

### General DevOps

- **Automate Everything:** Manual processes are error-prone
- **Infrastructure as Code:** Version control all configurations
- **Immutable Infrastructure:** Replace, don't modify
- **Continuous Monitoring:** Observe everything
- **Regular Updates:** Patch management
- **Disaster Recovery:** Test backups regularly

### Deployment

- **Test in Staging:** Never deploy untested code to production
- **Blue-Green or Canary:** Minimize deployment risk
- **Health Checks:** Verify before routing traffic
- **Automatic Rollback:** Quick recovery from failures
- **Documentation:** Document all procedures

### Security

- **Harden Before Deploy:** Security first
- **Regular Audits:** Continuous compliance
- **Monitor Logs:** Detect anomalies
- **Update Regularly:** Patch vulnerabilities
- **Backup Everything:** Disaster recovery ready

---

## Troubleshooting

### Common Issues

**Deployment Fails:**
- Check CI/CD logs for errors
- Verify credentials and permissions
- Test deployment script locally
- Check resource availability

**SSL/TLS Issues:**
- Verify domain ownership
- Check certificate paths
- Ensure port 80/443 open
- Verify DNS configuration

**Performance Problems:**
- Monitor resource usage
- Check application logs
- Review configuration settings
- Profile and benchmark

**Security Alerts:**
- Investigate immediately
- Check audit logs
- Verify firewall rules
- Review access patterns

---

## Metrics & Monitoring

### Key Metrics

**Deployment:**
- Deployment frequency
- Lead time for changes
- Change failure rate
- Mean time to recovery (MTTR)

**Server:**
- CPU usage
- Memory usage
- Disk usage
- Network throughput

**Security:**
- Failed login attempts
- Intrusion detection alerts
- Vulnerability count
- Patch compliance

---

## Resources

### Documentation
- Agent definitions: `/agents/deploy-specialist.md`, `/agents/web-server-setup.md`, `/agents/server-management.md`
- Skill definitions: `/skills/deploy-automation/`, `/skills/server-hardening/`, `/skills/webserver-configuration/`

### External Resources
- CIS Benchmarks: https://www.cisecurity.org/cis-benchmarks
- Nginx Documentation: https://nginx.org/en/docs/
- Kubernetes Documentation: https://kubernetes.io/docs/
- Let's Encrypt: https://letsencrypt.org/

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-21 | Initial release of DevOps agents and skills |

---

**Maintained by:** Lucas Catão de Moraes  
**Last Updated:** 2026-03-21
