# Setup Documentation

This directory contains comprehensive documentation for your development environment setup.

## Documents

### [SYSTEM_SETUP.md](SYSTEM_SETUP.md)
**Complete system setup documentation**

Everything about your environment:
- Bash configuration and enhancements
- Starship prompt setup
- Kubernetes tools (kubectl, k9s, kubectx/kubens)
- kind local cluster setup
- File locations
- Maintenance and updates
- Syncing to macOS

**Use this when:** You need detailed information about how everything is configured, or when setting up a new machine.

---

### [AGENT_CONTEXT.md](AGENT_CONTEXT.md)
**AI Agent context and reference**

Information for AI assistants to understand your environment:
- Available tools and commands
- Custom aliases and functions
- Best practices for suggestions
- Environment constraints (flatpak, etc.)
- Common workflows and patterns

**Use this when:** Working with AI assistants, or to remind yourself of all available shortcuts.

---

### [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
**Command quick reference**

Fast lookup for:
- All aliases (shell, git, kubectl, kind)
- All custom functions with examples
- Common workflows
- One-liners and tips
- Troubleshooting commands

**Use this when:** You need a quick reminder of command syntax or available shortcuts.

---

## Quick Start

### View Documentation
```bash
# In terminal
cat ~/docs/setup/SYSTEM_SETUP.md
cat ~/docs/setup/QUICK_REFERENCE.md

# Or open in editor
vim ~/docs/setup/SYSTEM_SETUP.md
code ~/docs/setup/
```

### Search Documentation
```bash
# Find all references to kubectl
grep -r "kubectl" ~/docs/setup/

# Find specific alias
grep "^alias k" ~/docs/setup/QUICK_REFERENCE.md

# Find function definition
grep -A 5 "kind-new" ~/docs/setup/QUICK_REFERENCE.md
```

## What's Configured

### ✅ Shell & Prompt
- Enhanced bash with 60+ aliases and functions
- Starship prompt showing git, k8s context, languages
- Smart history (10k commands, timestamps, deduplication)
- Auto-completion and typo correction

### ✅ Kubernetes Tools
- kubectl v1.34.1 with full completion
- kubectx/kubens for fast switching
- k9s terminal UI
- kind for local clusters

### ✅ Cross-Platform
- All configs work on Linux and macOS
- Platform-aware aliases (ls, etc.)
- Documented sync process

## Common Tasks

### See All Aliases
```bash
alias | grep -E '^alias k'     # kubectl aliases
alias | grep -E '^alias g'     # git aliases
alias | grep kind              # kind aliases
```

### See All Functions
```bash
declare -F | grep -E '(kind|k8s|kube)'
```

### Reload Configuration
```bash
source ~/.bashrc
```

### Backup Configuration
```bash
tar czf ~/config-backup-$(date +%Y%m%d).tar.gz \
  ~/.bashrc \
  ~/.bash_profile \
  ~/.config/starship.toml \
  ~/.config/kind/ \
  ~/docs/setup/
```

## Additional Resources

### Configuration Files
- `~/.bashrc` - Main bash config
- `~/.config/starship.toml` - Prompt config
- `~/.config/kind/*.yaml` - kind cluster templates
- `~/.config/kind/README.md` - kind usage guide

### External Documentation
- [Starship](https://starship.rs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [kind Documentation](https://kind.sigs.k8s.io/)
- [k9s Documentation](https://k9scli.io/)

## For AI Assistants

If you're an AI assistant helping this user:

1. **Read** `AGENT_CONTEXT.md` for environment details
2. **Reference** custom aliases and functions
3. **Suggest** kind for testing k8s workloads
4. **Use** helper functions (kshell, kgpw, kind-new, etc.)
5. **Remember** this is a learning environment

## Updates

To update this documentation:
```bash
# Edit files
vim ~/docs/setup/SYSTEM_SETUP.md
vim ~/docs/setup/AGENT_CONTEXT.md
vim ~/docs/setup/QUICK_REFERENCE.md

# Update date stamps at bottom of each file
```

---

**Created:** 2025-11-08
**Location:** ~/docs/setup/
**Maintained by:** yuandrk
