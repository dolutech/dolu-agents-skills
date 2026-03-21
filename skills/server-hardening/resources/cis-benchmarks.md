# CIS Benchmarks Implementation

Complete implementation guide for CIS (Center for Internet Security) Benchmarks on Linux servers.

## CIS Benchmark Levels

**Level 1:** Essential security controls (minimal impact on functionality)
**Level 2:** Enhanced security controls (may impact some functionality)

## Implementation by Category

### 1. Initial Setup

#### 1.1 Filesystem Configuration

```bash
# Ensure separate partition for /tmp
# Add to /etc/fstab
/tmp /tmp ext4 defaults,nosuid,nodev,noexec 0 2

# Mount /tmp
mount -o remount /tmp

# Ensure separate partition for /var
/dev/sda3 /var ext4 defaults,nosuid,nodev 0 2

# Ensure separate partition for /var/log
/dev/sda4 /var/log ext4 defaults,nosuid,nodev,noexec 0 2

# Ensure separate partition for /var/log/audit
/dev/sda5 /var/log/audit ext4 defaults,nosuid,nodev,noexec 0 2

# Ensure separate partition for /home
/dev/sda6 /home ext4 defaults,nosuid,nodev 0 2
```

#### 1.2 Configure Software Updates

```bash
# Install unattended-upgrades
apt-get install -y unattended-upgrades apt-listchanges

# Configure automatic updates
cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins::
    "${distro_id}:${distro_codename}-security";

Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Mail "admin@example.com";
Unattended-Upgrade::MailReport "on-change";
EOF

# Enable automatic updates
systemctl enable unattended-upgrades
systemctl start unattended-upgrades
```

### 2. Services

#### 2.1 Special Purpose Services

```bash
# Disable Avahi (not needed on servers)
systemctl disable avahi-daemon
systemctl stop avahi-daemon

# Disable CUPS (not needed on servers)
systemctl disable cups
systemctl stop cups
systemctl disable cups.socket
systemctl stop cups.socket

# Disable DHCP Server
systemctl disable isc-dhcp-server
systemctl stop isc-dhcp-server

# Disable DNS Server (if not needed)
systemctl disable bind9
systemctl stop bind9
```

#### 2.2 Client Services

```bash
# Disable NIS Client
systemctl disable nis-client
systemctl stop nis-client

# Disable RSH Client
apt-get remove --purge -y rsh-client rsh-redone-client

# Disable TFTP Client
apt-get remove --purge -y tftp
```

### 3. Network Configuration

#### 3.1 Disable Unused Network Protocols

```bash
# Disable IPv6 (if not needed)
cat >> /etc/sysctl.d/99-disable-ipv6.conf << EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

sysctl -p /etc/sysctl.d/99-disable-ipv6.conf

# Disable wireless interfaces (for servers)
cat >> /etc/modprobe.d/disable-wireless.conf << EOF
install bluetooth /bin/true
install ieee80211 /bin/true
EOF
```

#### 3.2 Network Parameters (IPv4)

```bash
# Configure kernel network parameters
cat >> /etc/sysctl.d/99-security.conf << 'EOF'
# Disable IP forwarding (if not a router)
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0

# Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Disable send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.secure_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

# Enable IP spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcasts
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Ignore bogus ICMP errors
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Enable TCP SYN cookies
net.ipv4.tcp_syncookies = 1

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore ICMP timestamp requests
net.ipv4.icmp_echo_ignore_all = 0
EOF

# Apply settings
sysctl -p /etc/sysctl.d/99-security.conf
```

#### 3.3 Configure Firewall

```bash
# Install and configure UFW
apt-get install -y ufw

# Reset and configure
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (rate limited)
ufw limit 22/tcp

# Allow HTTP/HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Enable logging
ufw logging on

# Enable firewall
ufw --force enable

# Verify
ufw status verbose
```

### 4. Logging and Auditing

#### 4.1 Install and Configure Auditd

```bash
# Install auditd
apt-get install -y auditd audispd-plugins

# Configure auditd
cat >> /etc/audit/rules.d/99-cis.rules << 'EOF'
# Delete all existing rules
-D

# Set buffer size
-b 8192

# Set failure mode
-f 1

# Monitor file system mounts
-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts
-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts

# Monitor user/group changes
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/gshadow -p wa -k identity

# Monitor sudo usage
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers

# Monitor SSH configuration
-w /etc/ssh/sshd_config -p wa -k sshd

# Monitor network configuration
-w /etc/hosts -p wa -k hosts
-w /etc/network/ -p wa -k network

# Monitor cron
-w /etc/crontab -p wa -k cron
-w /etc/cron.d -p wa -k cron
-w /etc/cron.daily -p wa -k cron
-w /etc/cron.hourly -p wa -k cron
-w /etc/cron.monthly -p wa -k cron
-w /etc/cron.weekly -p wa -k cron

# Monitor authentication
-w /var/log/auth.log -p wa -k auth_log
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins

# Monitor privilege escalation
-a always,exit -F arch=b64 -S setuid -S setgid -F auid>=1000 -F auid!=4294967295 -k privilege_escalation
-a always,exit -F arch=b32 -S setuid -S setgid -F auid>=1000 -F auid!=4294967295 -k privilege_escalation

# Monitor successful file deletions
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k file_deletion
-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k file_deletion

# Monitor kernel module loading
-w /sbin/insmod -p x -k modules
-w /sbin/modprobe -p x -k modules
-w /sbin/rmmod -p x -k modules

# Make configuration immutable (requires reboot to change)
# -e 2
EOF

# Restart auditd
systemctl restart auditd
systemctl enable auditd
```

#### 4.2 Configure Log Rotation

```bash
# Configure logrotate for security logs
cat > /etc/logrotate.d/security << 'EOF'
/var/log/auth.log
/var/log/syslog
/var/log/kern.log
/var/log/audit/audit.log
{
    rotate 12
    weekly
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
    create 0640 syslog adm
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
EOF
```

### 5. Access Control

#### 5.1 Configure PAM

```bash
# Install pam_pwquality
apt-get install -y libpam-pwquality

# Configure password quality
cat > /etc/pam.d/common-password << 'EOF'
password requisite pam_pwquality.so retry=3 minlen=14 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1
password required pam_unix.so sha512 shadow
EOF

# Configure account lockout
cat >> /etc/pam.d/common-auth << 'EOF'
auth required pam_faillock.so preauth audit deny=5 unlock_time=900
auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
EOF

# Configure password history
cat >> /etc/pam.d/common-password << 'EOF'
password required pam_pwhistory.so use_authtok remember=24
EOF
```

#### 5.2 Configure sudo

```bash
# Install sudo if not installed
apt-get install -y sudo

# Configure sudo
cat > /etc/sudoers.d/hardening << 'EOF'
# Log all sudo commands
Defaults logfile="/var/log/sudo.log"
Defaults log_input, log_output

# Require password for sudo
Defaults timestamp_timeout=5

# Secure path
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Restrict sudo access to specific group
%sudo ALL=(ALL:ALL) ALL
EOF

# Set proper permissions
chmod 440 /etc/sudoers.d/hardening
```

#### 5.3 SSH Hardening

```bash
# Backup original config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)

# Hardened SSH configuration
cat > /etc/ssh/sshd_config << 'EOF'
# Network
Port 2222
AddressFamily inet
ListenAddress 0.0.0.0

# Protocol
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key

# Authentication
PermitRootLogin no
MaxAuthTries 3
MaxSessions 10
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
KerberosAuthentication no
GSSAPIAuthentication no
HostbasedAuthentication no
IgnoreRhosts yes

# Keys
AuthorizedKeysFile .ssh/authorized_keys
HostbasedKnownHosts /etc/ssh/ssh_known_hosts

# Security
X11Forwarding no
AllowTcpForwarding no
AllowAgentForwarding no
PermitTunnel no
GatewayPorts no
ClientAliveInterval 300
ClientAliveCountMax 2
LoginGraceTime 60
StrictModes yes
PermitUserEnvironment no

# Cryptography
KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

# Logging
SyslogFacility AUTH
LogLevel VERBOSE

# Banner
Banner /etc/issue.net

# Subsystem
Subsystem sftp /usr/lib/openssh/sftp-server -f AUTHPRIV -l INFO

# Access control
AllowGroups sudo admin
DenyUsers root
EOF

# Create SSH banner
cat > /etc/issue.net << 'EOF'
***************************************************************************
                            AUTHORIZED ACCESS ONLY
***************************************************************************
This system is for authorized users only. All activity may be monitored
and recorded. Unauthorized access is prohibited and will be prosecuted.
***************************************************************************
EOF

# Generate new host keys
rm /etc/ssh/ssh_host_*
ssh-keygen -A

# Set proper permissions
chmod 600 /etc/ssh/sshd_config
chmod 644 /etc/issue.net

# Restart SSH
systemctl restart sshd
```

### 6. User Accounts and Environment

#### 6.1 Account Settings

```bash
# Set password expiration
chage -M 90 -m 7 -W 14 root

# Set default password expiration for new users
cat >> /etc/default/useradd << EOF
EXPIRE=90
INACTIVE=14
EOF

# Lock unused accounts
usermod -L games
usermod -L lists
usermod -L news
usermod -L uucp

# Remove unused accounts (if not needed)
userdel -r games
userdel -r news
```

#### 6.2 User Shell Timeout

```bash
# Set shell timeout
cat >> /etc/profile.d/tmout.sh << 'EOF'
TMOUT=900
readonly TMOUT
export TMOUT
EOF

chmod 644 /etc/profile.d/tmout.sh
```

#### 6.3 Restrict Access to su

```bash
# Restrict su to wheel group
cat > /etc/pam.d/su << 'EOF'
auth sufficient pam_rootok.so
auth required pam_wheel.so use_uid group=sudo
@include common-auth
@include common-account
@include common-session
EOF
```

### 7. File Permissions

#### 7.1 System File Permissions

```bash
# Secure sensitive files
chmod 644 /etc/passwd
chmod 644 /etc/group
chmod 640 /etc/shadow
chmod 640 /etc/gshadow
chmod 644 /etc/hosts
chmod 600 /etc/hosts.allow
chmod 600 /etc/hosts.deny
chmod 600 /etc/ssh/sshd_config
chmod 644 /etc/issue
chmod 644 /etc/issue.net
chmod 600 /etc/crontab
chmod 700 /etc/cron.d
chmod 700 /etc/cron.daily
chmod 700 /etc/cron.hourly
chmod 700 /etc/cron.monthly
chmod 700 /etc/cron.weekly
```

#### 7.2 World-Writable Files

```bash
#!/bin/bash
# Find and fix world-writable files

echo "=== World-Writable Files ==="
find / -type f -perm -002 -exec ls -l {} \; 2>/dev/null

echo -e "\n=== World-Writable Directories ==="
find / -type d -perm -002 -exec ls -ld {} \; 2>/dev/null

echo -e "\n=== SUID Binaries ==="
find / -type f -perm -4000 -exec ls -l {} \; 2>/dev/null

echo -e "\n=== SGID Binaries ==="
find / -type f -perm -2000 -exec ls -l {} \; 2>/dev/null
```

### 8. Verification

#### 8.1 Run Lynis Audit

```bash
#!/bin/bash
# Run security audit

echo "=== Running Lynis Security Audit ==="
lynis audit system

echo -e "\n=== CIS Score ==="
lynis show categories 2>/dev/null | head -20

echo -e "\n=== Warnings ==="
grep "warning\[" /var/log/lynis.log | tail -20

echo -e "\n=== Suggestions ==="
grep "suggestion\[" /var/log/lynis.log | tail -20
```

#### 8.2 Verify Hardening

```bash
#!/bin/bash
# Verify hardening status

echo "=== SSH Configuration ==="
sshd -T | grep -E "^(port|permitrootlogin|passwordauthentication|pubkeyauthentication)"

echo -e "\n=== Firewall Status ==="
ufw status verbose

echo -e "\n=== Auditd Status ==="
systemctl status auditd --no-pager
auditctl -l | head -20

echo -e "\n=== Failed Login Attempts ==="
grep "Failed password" /var/log/auth.log | tail -10 || echo "No failed logins"

echo -e "\n=== Security Packages ==="
dpkg -l | grep -E "(fail2ban|rkhunter|chkrootkit|lynis|unattended-upgrades)"

echo -e "\n=== Kernel Parameters ==="
sysctl net.ipv4.ip_forward
sysctl net.ipv4.tcp_syncookies
sysctl net.ipv4.conf.all.rp_filter
```

## Compliance Reporting

### Generate Compliance Report

```bash
#!/bin/bash
# Generate CIS compliance report

REPORT_DATE=$(date +%Y%m%d)
REPORT_FILE="/root/cis_compliance_${REPORT_DATE}.pdf"

echo "Generating CIS Compliance Report..."

{
    echo "CIS Benchmark Compliance Report"
    echo "================================"
    echo ""
    echo "Date: $(date)"
    echo "Hostname: $(hostname)"
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo ""
    
    echo "=== System Updates ==="
    apt list --upgradable 2>/dev/null | wc -l
    echo "packages pending update"
    echo ""
    
    echo "=== Security Services ==="
    systemctl is-active fail2ban
    systemctl is-active auditd
    systemctl is-active ufw
    echo ""
    
    echo "=== SSH Hardening ==="
    sshd -T | grep -E "^(port|permitrootlogin|passwordauthentication)"
    echo ""
    
    echo "=== Firewall Rules ==="
    ufw status | head -20
    echo ""
    
    echo "=== Lynis Score ==="
    lynis audit system 2>&1 | grep "Hardening index" || echo "Not available"
    
} > /root/cis_compliance_${REPORT_DATE}.txt

echo "Report saved to: /root/cis_compliance_${REPORT_DATE}.txt"
```

## Maintenance

### Monthly Hardening Review

```bash
#!/bin/bash
# Monthly security review

echo "=== Monthly Security Review ==="
echo "Date: $(date)"

echo -e "\n1. System Updates:"
apt-get update
apt list --upgradable 2>/dev/null | head -10

echo -e "\n2. Failed Logins (Last 30 days):"
grep "Failed password" /var/log/auth.log | since "30 days ago" | wc -l

echo -e "\n3. New User Accounts:"
grep "useradd" /var/log/auth.log | since "30 days ago" || echo "None"

echo -e "\n4. Sudo Usage:"
grep "sudo:" /var/log/auth.log | since "30 days ago" | wc -l

echo -e "\n5. Firewall Status:"
ufw status | head -10

echo -e "\n6. Audit Log Size:"
du -sh /var/log/audit/

echo -e "\n7. Disk Usage:"
df -h | grep -E "^/dev"

echo -e "\n8. Security Package Versions:"
dpkg -l | grep -E "(fail2ban|ufw|rkhunter)" | awk '{print $2, $3}'
```
