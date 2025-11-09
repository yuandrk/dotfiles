# AI Agent Context - System Environment

This document provides context for AI assistants (like Claude Code, GitHub Copilot, etc.) to understand the development environment setup.

---

## Environment Overview

### System Information
- **OS:** Linux (Fedora 43)
- **Runtime:** Flatpak environment (VSCode running in flatpak)
- **Shell:** Bash 5.x
- **Prompt:** Starship v1.24.0
- **User:** yuandrk
- **Home:** /home/yuandrk
- **Working Directory:** /home/yuandrk

### Environment Type
This is a **sandboxed flatpak environment** where:
- Some system binaries may not be directly accessible
- Docker runs on the host and is accessed via flatpak-spawn
- File paths are standard but execution context is containerized
- Shell scripts work normally within the flatpak sandbox

---

## Available Tools & Commands

### Shell & Prompt
- **bash** with enhanced configuration
- **starship** prompt (shows git, k8s context, languages, etc.)
- History: 10k commands with timestamps
- Smart completion and typo correction enabled

### Version Control
- **git** (standard commands)
- Git aliases: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`
- Git-aware prompt showing branch and dirty state

### Kubernetes Tools
All installed in `~/.local/bin/`:
- **kubectl** v1.34.1 - Full completion enabled
- **kubectx** v0.9.5 - Context switching
- **kubens** v0.9.5 - Namespace switching
- **k9s** v0.50.16 - Terminal UI
- **kind** v0.26.0 - Local clusters (requires Docker)

### Container Tools
- **Docker** v28.5.1 (on host, accessed via flatpak-spawn)
- **kind** configured to work with host Docker

### Text Editors
- **vim** (default EDITOR and VISUAL)
- **VSCode** (running in flatpak)

---

## Custom Aliases & Functions

### General Shell Aliases
When suggesting commands, you can use these aliases:

#### Navigation
- `..` = cd ..
- `...` = cd ../..
- `....` = cd ../../..

#### File Operations
- `ll` = ls -lh with colors
- `la` = ls -lhA with colors (include hidden)
- `rm`, `cp`, `mv` = Interactive versions (-i flag)

#### Utilities
- `h` = history
- `path` = Show PATH one entry per line
- `now` = Current time
- `nowdate` = Current date (YYYY-MM-DD)

### Git Aliases
- `gs` = git status
- `ga` = git add
- `gc` = git commit
- `gp` = git push
- `gl` = git log --oneline --graph --decorate
- `gd` = git diff

### Kubernetes Aliases

#### Basic Commands
- `k` = kubectl (with completion)
- `kgp` = kubectl get pods
- `kgs` = kubectl get svc
- `kgd` = kubectl get deployments
- `kgn` = kubectl get nodes
- `kga` = kubectl get all
- `kgpa` = kubectl get pods --all-namespaces

#### Describe Operations
- `kdp` = kubectl describe pod
- `kds` = kubectl describe svc
- `kdd` = kubectl describe deployment
- `kdn` = kubectl describe node

#### Other Operations
- `kl` = kubectl logs
- `klf` = kubectl logs -f
- `kex` = kubectl exec -it
- `kap` = kubectl apply -f
- `kdel` = kubectl delete
- `kdelp` = kubectl delete pod

#### Context & Namespace
- `kctx` = kubectx
- `kns` = kubens
- `kgc` = kubectl config get-contexts
- `kcc` = kubectl config current-context

### kind Aliases
- `kind-create` = kind create cluster
- `kind-delete` = kind delete cluster
- `kind-list` = kind get clusters
- `kind-load` = kind load docker-image

### Custom Functions Available

#### General
- `mkcd <dir>` - Create and cd into directory
- `extract <file>` - Auto-extract any archive
- `ff <pattern>` - Find files by name
- `fd <pattern>` - Find directories by name

#### Kubernetes
- `kshell <pod> [container]` - Open shell in pod
- `kbash <pod> [container]` - Open bash in pod
- `kgpw <pattern>` - Find pods by name pattern
- `kwp` - Watch pods (refreshes every 2s)
- `kevents` - Get events sorted by time
- `kpf <pod> <port>` - Port forward
- `ktop [pods|nodes]` - Resource usage
- `krestart <deployment>` - Restart deployment

#### kind
- `kind-new <name>` - Create cluster with custom name
- `kind-multi [name]` - Create multi-node cluster
- `kind-with-ports [name]` - Create cluster with port mappings
- `kind-clean` - Delete all kind clusters
- `kind-use <name>` - Switch to kind cluster context
- `kind-img <image> [cluster]` - Load image into cluster
- `kind-nodes [cluster]` - Show nodes in cluster

---

## File Locations

### Configuration Files
```
~/.bashrc                    # Main bash config (DO NOT overwrite without backing up)
~/.bash_profile              # Sources .bashrc
~/.config/starship.toml      # Starship config
~/.config/kind/*.yaml        # kind cluster configs
```

### Installed Binaries
```
~/.local/bin/
├── starship              # Prompt
├── kubectl              # Kubernetes CLI
├── kubectx              # Context switcher
├── kubens               # Namespace switcher
├── k9s                  # Terminal UI
├── kind                 # Wrapper script
└── kind-binary          # Actual kind binary
```

### Documentation
```
~/docs/setup/
├── SYSTEM_SETUP.md          # Complete setup documentation
├── AGENT_CONTEXT.md         # This file
└── QUICK_REFERENCE.md       # Command reference
```

---

## When Helping with Kubernetes Tasks

### Context Awareness
The user has a **learning/testing environment** with:
- Local kind clusters for experimentation
- kubectl fully configured and aliased
- k9s for visual cluster management
- All standard k8s tools available

### Suggest Appropriate Commands
When helping with k8s tasks:

✅ **DO:**
- Use short aliases: `k get pods` instead of `kubectl get pods`
- Suggest helper functions: `kshell my-pod` instead of `kubectl exec -it my-pod -- /bin/sh`
- Recommend k9s for complex debugging: `k9s -n namespace`
- Use kind for testing: `kind-new test-cluster`
- Leverage kubectx/kubens: `kctx` and `kns` for switching

❌ **DON'T:**
- Assume cloud providers (AWS, GCP, Azure) unless mentioned
- Suggest installing tools that are already installed
- Recommend Docker Desktop (using Docker Engine)
- Suggest complex manifests without testing in kind first

### Example Workflows to Suggest

#### Testing a Deployment
```bash
# Create test cluster
kind-new test

# Apply manifests
k apply -f deployment.yaml

# Check status
kgp
k9s  # For visual debugging

# Clean up
kind delete cluster --name test
```

#### Debugging a Pod
```bash
# Find the pod
kgpw my-app

# Get logs
klf my-app-pod-xxx

# Shell into it
kshell my-app-pod-xxx

# Or use k9s
k9s
```

---

## When Writing Scripts

### Shebang
Always use:
```bash
#!/usr/bin/env bash
```

### Environment Variables
These are set:
- `EDITOR=vim`
- `VISUAL=vim`
- `HISTSIZE=10000`
- `HISTFILESIZE=20000`
- `PATH` includes `~/.local/bin`

### Best Practices
1. Scripts should be executable: `chmod +x script.sh`
2. Prefer `~/.local/bin/` for user scripts
3. Use the custom functions when applicable
4. Test in kind before production clusters

---

## When Suggesting Installations

### ✅ Already Installed
- bash, git, vim
- starship, kubectl, kubectx, kubens, k9s, kind
- Docker (on host)

### 🔧 May Need Installation
Check first with `which <tool>` or `command -v <tool>`:
- Language runtimes (node, python, go, rust, etc.)
- Build tools (make, gcc, etc.)
- Other utilities (jq, yq, helm, etc.)

### Installation Location
Prefer `~/.local/bin/` for user binaries:
```bash
curl -LO <url>
chmod +x <binary>
mv <binary> ~/.local/bin/
```

---

## Working with Docker

### Special Consideration
This is a flatpak environment. Docker commands work but:
- Docker daemon runs on host
- kind uses a wrapper script to access host Docker
- Regular docker commands work via flatpak-spawn

### When Suggesting Docker Commands
✅ Regular docker commands work:
```bash
docker ps
docker images
docker build -t myapp:v1 .
```

✅ For kind, use the helper functions:
```bash
docker build -t myapp:v1 .
kind-img myapp:v1          # Loads into kind cluster
```

❌ Don't suggest:
- Editing docker daemon config (host-managed)
- Docker Desktop specific features
- Modifying /var/run/docker.sock directly

---

## Code Suggestions

### Language Detection
Starship automatically shows versions when in project directories for:
- Node.js (.nvmrc, package.json)
- Python (.python-version, requirements.txt, pyproject.toml)
- Go (go.mod)
- Rust (Cargo.toml)
- Java (pom.xml, build.gradle)
- And many more...

### When Suggesting Commands
Consider the detected language and suggest appropriate commands:
```bash
# Node.js detected
npm install
npm run dev

# Python detected
pip install -r requirements.txt
python app.py

# Go detected
go mod download
go run main.go
```

---

## Kubernetes Manifest Suggestions

### Default Namespace
If no namespace specified, assume `default`.

### Testing Approach
Always suggest testing in kind first:
```bash
# 1. Create test cluster
kind-new test

# 2. Apply and test
k apply -f manifest.yaml
kgp
k logs <pod>

# 3. Clean up
kind delete cluster --name test
```

### Common Patterns
User is learning k8s, so:
- Explain what each field does
- Suggest using k9s to visualize: `k9s`
- Recommend helper functions for common tasks
- Point to kind configs: `~/.config/kind/*.yaml`

---

## Prompt Engineering Tips

### Current Prompt Shows
- User@Host (yuandrk@hostname)
- Current directory (colored, truncated intelligently)
- Git branch and status (if in git repo)
- Kubernetes context and namespace (if kubeconfig active)
- Language versions (if in project directory)
- Execution time (for slow commands)
- Current time

### Understanding User's View
When user says "my prompt shows...", they're referring to Starship output which includes all the above context.

---

## Common User Workflows

### 1. Learning Kubernetes
```bash
# Create learning cluster
kind-new learning

# Deploy examples
k create deployment nginx --image=nginx
k expose deployment nginx --port=80

# Explore with k9s
k9s

# Clean up
kind delete cluster --name learning
```

### 2. Testing Manifests
```bash
# Create test cluster with ports
kind-with-ports test

# Apply manifests
k apply -f .

# Check with aliases
kgp
kgs
kevents

# Debug
k9s
```

### 3. Multi-Node Testing
```bash
# Create multi-node cluster
kind-multi advanced

# Check nodes
kgn
kind-nodes advanced

# Test scheduling
k apply -f deployment.yaml
k get pods -o wide  # See which node
```

---

## Error Handling Suggestions

### Docker Permission Issues
If kind shows Docker permission errors:
```bash
# User needs to run on host (not in flatpak):
sudo usermod -aG docker $USER
newgrp docker
```

### Context Not Found
If kubectl shows context errors:
```bash
# List contexts
kgc

# Switch context
kctx kind-<cluster-name>

# Or use helper
kind-use <cluster-name>
```

### Command Not Found
If custom function not found:
```bash
# Reload bashrc
source ~/.bashrc
```

---

## Documentation References

When user asks for help:
1. Check `~/docs/setup/SYSTEM_SETUP.md` first
2. Refer to `~/.config/kind/README.md` for kind examples
3. Suggest built-in help: `k explain <resource>`

---

## Best Practices for Agent Interactions

### DO:
- ✅ Use established aliases and functions
- ✅ Suggest k9s for complex debugging
- ✅ Recommend testing in kind first
- ✅ Explain what commands do (user is learning)
- ✅ Reference the documentation files
- ✅ Consider the flatpak environment context
- ✅ Leverage Starship's context awareness

### DON'T:
- ❌ Overwrite `.bashrc` without explicit permission
- ❌ Assume cloud provider access
- ❌ Suggest installing already-installed tools
- ❌ Recommend production actions for learning scenarios
- ❌ Ignore the custom functions and aliases
- ❌ Forget this is a learning/testing environment

---

## Quick Decision Tree

```
User asks about Kubernetes?
├─ Is it a learning question?
│  └─ Suggest kind cluster + explanation + k9s
├─ Is it debugging?
│  └─ Use kgpw, klf, kshell, or k9s
├─ Is it deployment?
│  └─ Test in kind first, use helper functions
└─ Is it context switching?
   └─ Use kctx/kns

User asks about shell/bash?
├─ Check if custom function exists
├─ Suggest using aliases
└─ Reference SYSTEM_SETUP.md

User asks about installation?
├─ Check: which <tool>
├─ Already installed? → Just explain usage
└─ Not installed? → Suggest ~/.local/bin install

User shows error?
├─ Docker permission? → Host commands needed
├─ kubectl context? → kctx/kind-use
├─ Command not found? → source ~/.bashrc
└─ Other? → Debug with provided tools
```

---

## Summary for Agents

This user has:
- ✅ Fully configured bash environment with many helper functions
- ✅ Complete Kubernetes toolkit (kubectl, kind, k9s, kubectx/kubens)
- ✅ Beautiful Starship prompt with context awareness
- ✅ Local k8s testing capability with kind
- ✅ Learning-focused setup (not production)

When helping:
- Use the custom aliases and functions
- Suggest kind for testing
- Explain concepts (user is learning)
- Reference the documentation
- Consider the flatpak environment

---

**Agent Type:** AI Assistant (Claude Code, Copilot, etc.)
**Last Updated:** 2025-11-08
**Version:** 1.0
