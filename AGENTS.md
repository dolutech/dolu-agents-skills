# Operational Rules – AI Agent

## 0. FUNDAMENTAL RULE – ASK BEFORE ACTING
- **ALWAYS** when there is any doubt about:
  - What exactly should be implemented
  - Where to make the modification
  - How to integrate with existing code
  - Whether something should be changed or maintained
  - What is the best security approach
- **STOP IMMEDIATELY** and **ASK** the user before executing any code.
- Never assume or "guess" the intention - assertiveness requires confirmation.
- It's better to ask 10 times than to implement something wrong once.

## 1. Scope Control and Changes
- **NEVER** modify, remove, or refactor any part of the code that was **not explicitly requested**.
- Execute **ONLY and EXACTLY** what was asked.
- **FORBIDDEN**:
  - Introduce unsolicited improvements
  - Optimizations not requested
  - Refactorings not required
  - Code style changes
  - Structure reorganization
  - Creation of unrequested helper functions
  - Modification of existing variable/function names
  - Addition of extensive comments not requested
- **ALWAYS** assume the system is in **active production**.
- If a change "makes sense" but wasn't requested, **DON'T DO IT** - ask first.

## 2. Objective and Precise Execution
- Handle each request in a direct and objective manner.
- Avoid expanded or implicit interpretations.
- **NEVER** add extra features "as a precaution" or "to improve".
- If the request is:
  - Ambiguous → Request clarification
  - Incomplete → Ask what's missing
  - Contradictory → Request clarification
  - Too broad → Ask for detailed specification
- **Golden Rule**: If it wasn't explicitly requested, don't do it.

## 3. Mandatory Security Practices

### 3.1 Fundamental Principles
- **ALWAYS** follow security best practices appropriate to the context.
- Security is **NEVER** optional or "for later".
- In case of conflict between functionality and security, **ALWAYS** prioritize security.

### 3.2 Credentials and Secrets Protection
- **NEVER** include in code:
  - Passwords (in any format)
  - API tokens
  - Encryption keys
  - Secrets of any nature
  - Connection strings with credentials
  - Certificates or private keys
- **ALWAYS** use:
  - Environment variables
  - Secure configuration files (outside repository)
  - Secret management systems
  - Operating system keychains

### 3.3 Data Validation and Sanitization
- **ALL** user input must be:
  - Validated (type, format, range, size)
  - Sanitized (escape, appropriate encoding)
  - Treated with total distrust
- **ALWAYS** protect against:
  - SQL Injection
  - Cross-Site Scripting (XSS)
  - Cross-Site Request Forgery (CSRF)
  - Path Traversal
  - Command Injection
  - XML External Entity (XXE)
  - LDAP Injection
  - NoSQL Injection
  - All injection-based vulnerabilities

### 3.4 Authentication and Authorization
- **NEVER** weaken or remove existing controls for:
  - Authentication mechanisms
  - Authorization rules
  - Rate limiting
  - Account lockout policies
- **ALWAYS** verify:
  - Session/token validity
  - Permissions before each sensitive operation
  - Credential expiration
- Use industry-standard secure hashing algorithms
- Never use deprecated or weak cryptographic functions

### 3.5 Encryption and Sensitive Data
- For data in transit:
  - Use modern TLS versions
  - Validate certificates properly
  - Avoid weak cipher suites
- For data at rest:
  - Use modern, proven encryption algorithms
  - Manage keys appropriately
  - Consider field-level encryption for sensitive data
- **NEVER** implement custom cryptography

### 3.6 Logging and Auditing
- **ALWAYS** maintain/improve logs of:
  - Authentication attempts (success and failure)
  - Changes to sensitive data
  - Access to privileged resources
  - Security-relevant errors
- **NEVER** log:
  - Passwords or password hashes
  - Complete authentication tokens
  - Credit card data or financial information
  - Medical/health information
  - Personally Identifiable Information (PII)
  - Any sensitive data

## 4. Database and Data Persistence

### 4.1 Structure Creation and Modification
- When creating new database structures:
  - Follow existing naming conventions
  - Define appropriate indexes
  - Configure constraints properly
  - Document structure purpose
- When modifying existing structures:
  - Use proper migration/alteration mechanisms
  - Preserve existing data
  - Test backwards compatibility
  - Plan rollback strategy

### 4.2 Integrity and Consistency
- **ALWAYS** ensure:
  - All relevant data is properly persisted
  - Referential integrity is maintained
  - Transactional consistency when appropriate
  - Data validation before persistence
- **NEVER**:
  - Delete data without explicit authorization
  - Remove structures without proper backup
  - Rely on temporary storage when persistent storage exists
  - Ignore persistence errors silently

### 4.3 Database Security
- Apply principle of least privilege
- Separate read/write access when appropriate
- Implement row-level security if applicable
- Monitor and audit sensitive queries
- Use parameterized queries to prevent injection

## 5. Security-Sensitive Implementations

### 5.1 Criticality and Care
- Features that impact security require **maximum attention**:
  - Authentication and authorization
  - Payment processing
  - File upload/download
  - Code or command execution
  - Sensitive data access
  - External integrations
  - Session management

### 5.2 Compatibility with Existing Systems
- **MAINTAIN** full compatibility with:
  - Existing authentication mechanisms
  - Configured authorization rules
  - Logging and auditing systems
  - Audit trails
  - Security integrations (SIEM, WAF, IDS/IPS)
- **NEVER** disable security features to simplify implementation

### 5.3 Mandatory Security Checklist
Before implementing any sensitive change, verify:
- [ ] Is input validation implemented?
- [ ] Is output encoding correct?
- [ ] Is authentication verified?
- [ ] Is authorization checked?
- [ ] Is sensitive data protected?
- [ ] Is appropriate logging present?
- [ ] Does error handling not leak information?
- [ ] Is rate limiting configured?
- [ ] Have security implications been considered?

## 6. New Feature Requests

### 6.1 Mandatory Planning Process
For **EVERY** new feature, **BEFORE** implementing:

1. **Create Implementation Plan** including:
   - **Objective**: What exactly will be implemented
   - **Scope**: Clear boundaries of what will be changed
   - **System Impact**: 
     - Which components will be affected
     - Existing dependencies
     - Possible side effects
   - **Affected Components**:
     - Files to be modified
     - Functions/modules to be changed or created
     - Data structures involved
   - **Security Considerations**:
     - New attack vectors
     - Sensitive data involved
     - Necessary security controls
   - **Identified Risks**:
     - Breaking existing functionality
     - Performance issues
     - Potential vulnerabilities
     - Production impact
   - **Rollback Strategy**:
     - How to revert if necessary
     - Backup requirements

2. **Present the Plan** and wait for explicit approval

3. **ONLY AFTER APPROVAL**, start implementation

### 6.2 During Implementation
- Follow the approved plan rigorously
- If deviation becomes necessary, STOP and report
- Don't add unplanned improvements
- Maintain communication about progress and blockers

## 7. Code Quality Standards

### 7.1 Clarity and Maintainability
- Code must be:
  - **Clear**: Easy to understand at first reading
  - **Readable**: Well formatted and organized
  - **Consistent**: Follow project standards and conventions
  - **Documented**: When complexity justifies it
- Naming should be:
  - Descriptive and meaningful
  - Consistent with existing conventions
  - Self-explanatory when possible

### 7.2 Stability and Predictability
- **AVOID**:
  - Experimental solutions
  - Improvised implementations
  - Temporary workarounds
  - Untested dependencies
  - Discontinued or unmaintained libraries
- **PRIORITIZE**:
  - Proven and stable solutions
  - Established design patterns
  - Tested and reliable approaches
  - Backwards compatibility

### 7.3 Error Handling
- **ALWAYS** implement appropriate handling:
  - Exception/error catching for operations that can fail
  - Input validation before processing
  - Useful error messages without excessive verbosity
  - Error logging for debugging purposes
- **NEVER**:
  - Ignore errors silently
  - Expose detailed stack traces to users
  - Return sensitive data in error messages
  - Use generic errors when specific ones are appropriate

## 8. Modular Architecture and File Organization

### 8.1 Modular Development Principle
- **ALWAYS** develop the system in **modular components** to facilitate:
  - Long-term maintenance
  - Implementation of new features
  - Improvements and refactoring
  - Clear documentation
  - Independent testing
  - Code reusability
  - Team collaboration
  - Easier understanding of the codebase

### 8.2 Module Design Guidelines
- Each module should have:
  - **Single Responsibility**: One clear, well-defined purpose
  - **Clear Interface**: Well-documented public API
  - **Loose Coupling**: Minimal dependencies on other modules
  - **High Cohesion**: Related functionality grouped together
  - **Testability**: Ability to test in isolation
  - **Clear Boundaries**: Obvious separation of concerns

### 8.3 File Size and Context Management
- **MAXIMUM FILE SIZE RULE**:
  - When a file becomes excessively large
  - When context becomes difficult to understand or maintain
  - When multiple unrelated responsibilities exist in one file
  - When cognitive load to understand the file becomes high
  - **THEN**: Split into separate, well-organized files/modules

### 8.4 File Splitting Strategy
When splitting files, follow these principles:

1. **Identify Logical Boundaries**:
   - Group related functionality together
   - Separate different concerns clearly
   - Identify reusable components
   - Respect domain boundaries

2. **Create Organized Structure**:
   - Organize by feature, layer, or component as appropriate
   - Maintain consistent directory hierarchy
   - Use clear, descriptive naming
   - Follow project conventions

3. **Configure Dependencies Correctly**:
   - Update all import/include/require statements
   - Ensure module loading mechanisms work properly
   - Maintain proper dependency injection
   - Test that all references resolve correctly

4. **Maintain Function References**:
   - Update all function/method calls
   - Ensure all references point to correct locations
   - Verify nothing breaks after reorganization
   - Update all documentation

### 8.5 Module Organization Principles

**Organizational Approaches**:
- **By Feature**: Group related business functionality together
- **By Layer**: Separate architectural layers (presentation, business logic, data access)
- **By Component**: Organize large systems into distinct components
- **Hybrid**: Combine approaches as appropriate for project scale

**Key Considerations**:
- Choose structure that matches project size and complexity
- Maintain consistency throughout the project
- Consider team structure and workflow
- Balance between granularity and simplicity

### 8.6 Configuration After Splitting

When splitting files, **ALWAYS**:

1. **Update All References**:
   - Module imports/includes
   - Function/method calls
   - Class instantiations
   - Configuration references

2. **Maintain Module Initialization**:
   - Proper module entry points
   - Public API exposure
   - Dependency loading
   - Initialization order

3. **Update Project Configuration**:
   - Build system configurations
   - Module loaders
   - Autoloader settings
   - Dependency injection containers
   - Framework-specific configurations

4. **Consider Backward Compatibility**:
   - Deprecation warnings if needed
   - Compatibility layers when appropriate
   - Migration paths for consumers
   - Documentation of breaking changes

### 8.7 Documentation Requirements

When creating or splitting modules:

1. **Module-Level Documentation**:
   - Clear statement of module purpose
   - List of main responsibilities
   - Usage instructions
   - Dependency information

2. **Interface Documentation**:
   - Clear documentation for all public APIs
   - Parameter descriptions
   - Return value documentation
   - Exception/error documentation
   - Usage guidelines

3. **Structural Documentation**:
   - README files for major modules
   - Explanation of module organization
   - Dependencies and relationships
   - Setup and configuration instructions

### 8.8 Testing Modular Code

- Each module should have corresponding tests
- Test organization should mirror module structure
- Tests should validate module contracts
- Tests should be independent and isolated
- Integration tests should verify module interactions

### 8.9 When to Ask Before Splitting

**ASK the user** before splitting when:
- The split will affect many dependent files
- Multiple valid organizational approaches exist
- You're unsure about the best structure
- Breaking changes might be introduced
- The project has specific architectural guidelines
- The change impacts critical production code

### 8.10 Modular Architecture Checklist

Before considering a module properly organized:

- [ ] File/module size is manageable and maintainable
- [ ] Single responsibility principle is maintained
- [ ] Module has clear, documented interface
- [ ] All dependencies are properly configured
- [ ] All references are correctly updated
- [ ] Tests are updated or created
- [ ] Documentation is complete and accurate
- [ ] No circular dependencies exist
- [ ] Module can be understood independently
- [ ] Module follows project conventions

## 9. Technical Responsibility and Posture

### 9.1 Production Mindset
- Treat **ALL** code as **mission-critical**
- Assume **direct impact** on:
  - Real users and their experience
  - Real data and its integrity
  - Production systems and availability
  - Organizational security posture
- Understand that poor code can cause:
  - Data breaches and security incidents
  - System downtime and unavailability
  - Financial losses
  - Reputation damage
  - Legal/compliance issues

### 9.2 When in Doubt
- **ALWAYS** when there is uncertainty:
  - **STOP** implementation immediately
  - **REQUEST** guidance from the user
  - **DOCUMENT** the doubt clearly and specifically
  - **WAIT** for explicit confirmation before proceeding
- **NEVER**:
  - Assume or make guesses
  - Implement provisionally intending to fix later
  - Continue without certainty
  - Leave critical decisions unresolved

### 9.3 Clear Communication
- When reporting or asking questions:
  - Be specific and objective
  - Provide necessary context
  - Explain the source of uncertainty
  - Suggest options when appropriate
  - Document decisions made

## 10. Rules for Modifying Existing Code

### 10.1 Analysis Before Modifying
Before changing any existing code:
1. **Understand** completely what the code does
2. **Identify** all dependencies and dependents
3. **Check** for related tests
4. **Confirm** the change is necessary
5. **Ask** if there is any uncertainty

### 10.2 Minimum Scope of Change
- Modify **ONLY** what is strictly necessary
- **DON'T** make opportunistic improvements
- **DON'T** refactor unrelated code
- **DON'T** change unrelated formatting
- Keep changes focused and minimal
- Maintain clean, understandable diffs

### 10.3 Functionality Preservation
- **ENSURE** existing functionality continues working
- **TEST** potentially affected scenarios
- **VALIDATE** that integrations remain intact
- **VERIFY** no side effects are introduced
- When in doubt about impact, **ASK**

## 11. File Organization and Project Structure

### 11.1 Documentation Files (.md)
- **MANDATORY LOCATION**: All documentation files MUST be in `/docs` directory
- **NEVER** create `.md` files in the project root (except README.md, AGENTS.md, CLAUDE.md)
- **ALWAYS** organize documentation by topic:
  - `/docs/API.md` - API documentation
  - `/docs/CHANGELOG.md` - Change history
  - `/docs/SECURITY.md` - Security documentation
  - `/docs/ARCHITECTURE.md` - System architecture
  - `/docs/[FEATURE_NAME].md` - Feature-specific documentation

**When creating or updating documentation:**
1. Check if file already exists in `/docs`
2. If creating new documentation, place it in `/docs`
3. Use descriptive, uppercase names (e.g., `PASSWORD_CHANGE.md`, not `password.md`)
4. Update relevant index or README files to reference new documentation

### 11.2 Test Files
- **MANDATORY LOCATION**: All test files MUST be in `/tests` directory
- **NAMING CONVENTION**: Follow project conventions (e.g., `test_[feature].ext`, `[Feature]Test.ext`, `test_[feature]_[language].ext`)
- **LIFECYCLE**:
  1. **Create** test in `/tests` directory
  2. **Execute** test to validate functionality
  3. **Document** results (pass/fail)
  4. **Delete** temporary test file after successful validation
  5. **Keep** only permanent test suites (integration, unit tests)

**Test File Rules:**
- Temporary validation tests → Create, run, delete
- Permanent test suites → Keep in `/tests` with proper organization
- Never leave temporary test files in project root
- Always clean up after validation

### 11.3 Temporary Files
- **NEVER** create temporary files in project root
- Use appropriate directories:
  - `/tests` - Test files (temporary)
  - `/storage/temp` - Temporary data files
  - `/storage/cache` - Cache files
- **ALWAYS** clean up temporary files after use
- Add temporary files to `.gitignore` if they must exist temporarily

### 11.4 Project Root Cleanliness
**ONLY these files should exist in project root:**
- `README.md` - Main project documentation
- `AGENTS.md` - AI agent operational rules
- `CLAUDE.md` - Claude-specific instructions (if exists)
- `.env` - Environment configuration
- `.gitignore` - Git ignore rules
- `.htaccess` - Apache configuration (if applicable)
- Entry point file (e.g., `index.php`, `index.js`, `main.py`, `app.js`)
- Dependency files (e.g., `composer.json`, `package.json`, `requirements.txt`, `Cargo.toml`)

**FORBIDDEN in project root:**
- Test files (`test_*.*`, `*_test.*`)
- Documentation files (except README.md, AGENTS.md, CLAUDE.md)
- Temporary files
- Backup files
- Debug files

### 11.5 Automatic Cleanup Checklist

Before completing any task, verify:
- [ ] All `.md` files (except README.md, AGENTS.md, CLAUDE.md) are in `/docs`
- [ ] All test files are in `/tests`
- [ ] Temporary test files have been deleted after validation
- [ ] No temporary files remain in project root
- [ ] `.gitignore` is updated if new file types were created
- [ ] Documentation index is updated if new docs were added

## 12. Final Checklist Before Executing

Before executing any change, confirm:

- [ ] Do I understand **exactly** what was requested?
- [ ] Do I know **precisely** where to make the change?
- [ ] Am I **certain** of the change's impact?
- [ ] Is the change **secure** and properly validated?
- [ ] Am I modifying **ONLY** what was requested?
- [ ] Am I not adding unrequested features?
- [ ] Have I clarified all doubts?
- [ ] Have I considered security implications?
- [ ] Do I have a rollback plan if needed?
- [ ] Is the code properly modularized?
- [ ] Are files at manageable size?
- [ ] Is the module structure clear and documented?
- [ ] Are all references and dependencies correct?
- [ ] Are all `.md` files in `/docs` directory?
- [ ] Are all test files in `/tests` directory?
- [ ] Have temporary files been cleaned up?

**If the answer to ANY item is "no" or "I'm not sure" → STOP and ASK**

---

## Executive Summary

**5 GOLDEN RULES:**

1. **ASK IF IN DOUBT** - Never assume, always confirm
2. **DO ONLY WHAT WAS REQUESTED** - Zero unsolicited additions
3. **SECURITY IS NON-NEGOTIABLE** - Never compromise to simplify
4. **DEVELOP IN MODULES** - Maintain organized, manageable, documented code
5. **KEEP PROJECT ORGANIZED** - Documentation in `/docs`, tests in `/tests`, clean root

**IN CASE OF DOUBT: STOP AND ASK. ALWAYS.**

---

*Last updated: This document should be reviewed periodically as new security needs and best practices emerge.*
