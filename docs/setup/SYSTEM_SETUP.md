# System Setup Documentation

**Machine:** Linux Fedora 43 (Flatpak environment)
**User:** yuandrk
**Date:** 2025-11-08
**Shell:** Bash with Starship prompt

---

## Table of Contents

1. [Overview](#overview)
2. [Bash Configuration](#bash-configuration)
3. [Starship Prompt](#starship-prompt)
4. [Kubernetes Tools](#kubernetes-tools)
5. [kind (Local Kubernetes)](#kind-local-kubernetes)
6. [File Locations](#file-locations)
7. [Maintenance](#maintenance)

---

## Overview

This system is configured for a consistent development experience across Linux and macOS machines with focus on:
- Enhanced bash shell with productivity features
- Beautiful, informative Starship prompt
- Complete Kubernetes development environment
- Local Kubernetes testing with kind

### Key Features
- ✅ Enhanced bash history (10k commands with timestamps)
- ✅ Smart auto-completion and typo correction
- ✅ Git-aware Starship prompt
- ✅ Kubernetes context display in prompt
- ✅ 60+ kubectl aliases and helper functions
- ✅ Local Kubernetes clusters with kind
- ✅ k9s terminal UI for cluster management
- ✅ Works on both Linux and macOS

---

## Bash Configuration

### Location
`~/.bashrc` - Main bash configuration file
`~/.bash_profile` - Sources `.bashrc` on login

### Features Configured

#### History Settings
- **Size:** 10,000 commands in memory, 20,000 on disk
- **Deduplication:** No duplicate entries
- **Timestamps:** Every command has a timestamp
- **Append mode:** History is appended, not overwritten

#### Smart Bash Options
- `checkwinsize` - Auto-update terminal size
- `cdspell` - Auto-correct typos in paths
- `dirspell` - Auto-correct directory names in completion
- `nocaseglob` - Case-insensitive file matching

#### Color Support
- Colored `ls` output (platform-aware)
- Colored `grep` output
- Proper color codes for both Linux and macOS

### General Aliases

```bash
# Navigation
..          # cd ..
...         # cd ../..
....        # cd ../../..
~           # cd ~

# Enhanced ls
ll          # ls -lh with colors
la          # ls -lhA with colors (show hidden)

# Safe operations (interactive mode)
rm          # rm -i (confirm before delete)
cp          # cp -i (confirm before overwrite)
mv          # mv -i (confirm before overwrite)
mkdir       # mkdir -pv (create parent dirs, verbose)

# Utilities
h           # history
j           # jobs -l
path        # Display PATH nicely (one entry per line)
now         # Current time
nowdate     # Current date (YYYY-MM-DD)

# Git shortcuts
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git log --oneline --graph --decorate
gd          # git diff
```

### Useful Functions

#### `mkcd <directory>`
Create directory and cd into it in one command.
```bash
mkcd ~/projects/new-app
```

#### `extract <archive>`
Auto-detect and extract any archive type.
```bash
extract myfile.tar.gz
extract myfile.zip
extract myfile.7z
```

#### `ff <pattern>`
Find files by name (case-insensitive).
```bash
ff README
ff "*.js"
```

#### `fd <pattern>`
Find directories by name (case-insensitive).
```bash
fd node_modules
```

---

## Starship Prompt

### Installation
- **Version:** 1.24.0
- **Location:** `~/.local/bin/starship`
- **Config:** `~/.config/starship.toml`

### Features
The prompt automatically displays:
- Current user and hostname (green/blue colored)
- Current directory with smart truncation
- Git branch and status
  - Clean repo: cyan color
  - Dirty repo: red color with indicators
- Programming language versions (when in project directories)
  - Node.js, Python, Go, Rust, Java, etc.
- Docker context (when applicable)
- **Kubernetes context and namespace** (when in k8s project)
- Command execution time (for slow commands)
- Exit status for failed commands
- Current time

### Theme
**Pastel Powerline** - A beautiful color scheme with smooth transitions

### Customization
Edit `~/.config/starship.toml` to customize.

View available presets:
```bash
starship preset --list
```

Apply a different preset:
```bash
starship preset <preset-name> -o ~/.config/starship.toml
```

### Switching Back to Basic Prompt
If you want to use the basic bash prompt instead of Starship:

1. Edit `~/.bashrc`
2. Comment out: `eval "$(starship init bash)"`
3. Uncomment the `PS1=...` line and related color variables
4. Run: `source ~/.bashrc`

---

## Kubernetes Tools

### Installed Tools

#### kubectl (v1.34.1)
The official Kubernetes command-line tool.
- **Location:** `~/.local/bin/kubectl`
- **Completion:** Enabled for bash (tab completion works)

#### kubectx (v0.9.5)
Fast context switching between clusters.
```bash
kubectx                    # List contexts
kubectx <context>          # Switch context
kubectx -                  # Switch to previous context
```

#### kubens (v0.9.5)
Fast namespace switching.
```bash
kubens                     # List namespaces
kubens <namespace>         # Switch namespace
kubens -                   # Switch to previous namespace
```

#### k9s (v0.50.16)
Terminal UI for managing Kubernetes clusters.
```bash
k9s                        # Launch k9s
k9s -n <namespace>         # Launch in specific namespace
```

**k9s Quick Keys:**
- `:` - Command mode
- `/` - Filter
- `?` - Help
- `Ctrl+a` - Show all namespaces
- `0` - Show all pods
- `d` - Describe resource
- `l` - Show logs
- `Ctrl+d` - Delete resource

### Kubectl Aliases

#### Basic Operations
```bash
k           # kubectl
kgp         # kubectl get pods
kgs         # kubectl get svc
kgd         # kubectl get deployments
kgn         # kubectl get nodes
kga         # kubectl get all
kgpa        # kubectl get pods --all-namespaces
```

#### Describe Resources
```bash
kdp         # kubectl describe pod
kds         # kubectl describe svc
kdd         # kubectl describe deployment
kdn         # kubectl describe node
```

#### Other Operations
```bash
kdel        # kubectl delete
kl          # kubectl logs
klf         # kubectl logs -f (follow)
kex         # kubectl exec -it
kap         # kubectl apply -f
kdelp       # kubectl delete pod
```

#### Context & Namespace
```bash
kctx        # kubectx
kns         # kubens
kgc         # kubectl config get-contexts
kcc         # kubectl config current-context
```

### Kubectl Functions

#### `kshell <pod> [container]`
Open a shell in a pod.
```bash
kshell my-pod
kshell my-pod my-container
```

#### `kbash <pod> [container]`
Open bash in a pod (for pods with bash installed).
```bash
kbash my-pod
```

#### `kgpw <pattern>`
Find pods by name pattern.
```bash
kgpw nginx
kgpw "api-.*"
```

#### `kwp`
Watch pods (refreshes every 2 seconds).
```bash
kwp
```

#### `kevents`
Get events sorted by timestamp.
```bash
kevents
```

#### `kpf <pod> <port>`
Port forward to a pod.
```bash
kpf my-pod 8080
```

#### `ktop [pods|nodes]`
Show resource usage.
```bash
ktop pods
ktop nodes
ktop          # Show both
```

#### `krestart <deployment>`
Restart a deployment.
```bash
krestart my-app
```

---

## kind (Local Kubernetes)

### About kind
kind (Kubernetes IN Docker) runs Kubernetes clusters in Docker containers.
Perfect for:
- Learning Kubernetes
- Local development
- CI/CD testing
- Testing Helm charts
- Experimenting without cloud costs

### Installation
- **Version:** v0.26.0
- **Location:** `~/.local/bin/kind`
- **Configs:** `~/.config/kind/`

### Prerequisites
Docker must be running and your user must have Docker permissions:
```bash
# On host machine (not in flatpak)
sudo usermod -aG docker $USER
sudo systemctl restart docker
newgrp docker
```

### kind Aliases
```bash
kind-create     # kind create cluster
kind-delete     # kind delete cluster
kind-list       # kind get clusters
kind-load       # kind load docker-image
```

### kind Functions

#### `kind-new <name>`
Create a cluster with custom name.
```bash
kind-new learning
kind-new test-cluster
```

#### `kind-multi [name]`
Create a multi-node cluster (1 control-plane + 2 workers).
```bash
kind-multi
kind-multi my-cluster
```

#### `kind-with-ports [name]`
Create cluster with port mappings (80, 443, 30000).
```bash
kind-with-ports web-testing
```

#### `kind-clean`
Delete ALL kind clusters.
```bash
kind-clean
```

#### `kind-use <name>`
Switch kubectl context to specific kind cluster.
```bash
kind-use learning
```

#### `kind-img <image> [cluster]`
Load Docker image into kind cluster.
```bash
docker build -t my-app:v1 .
kind-img my-app:v1
kind-img nginx:latest my-cluster
```

#### `kind-nodes [cluster]`
Show nodes in a cluster.
```bash
kind-nodes
kind-nodes my-cluster
```

### Example Configurations

Located in `~/.config/kind/`:

#### simple-cluster.yaml
Single-node cluster for quick testing.
```bash
kind create cluster --config ~/.config/kind/simple-cluster.yaml
```

#### multi-node-cluster.yaml
Multi-node with 1 control-plane + 2 workers.
```bash
kind create cluster --config ~/.config/kind/multi-node-cluster.yaml
```

#### advanced-cluster.yaml
Advanced setup with:
- Port mappings (80, 443, 30000-30001)
- Ingress-ready configuration
- 1 control-plane + 2 workers

```bash
kind create cluster --config ~/.config/kind/advanced-cluster.yaml
```

### Quick Workflow Example

```bash
# 1. Create a cluster
kind create cluster --name dev

# 2. Verify cluster
kubectl cluster-info --context kind-dev
kubectl get nodes

# 3. Deploy an app
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort

# 4. Check deployment
kubectl get pods
kubectl get svc

# 5. Access the app
kubectl port-forward service/nginx 8080:80
# Visit http://localhost:8080

# 6. Clean up
kind delete cluster --name dev
```

---

## File Locations

### Configuration Files
```
~/.bashrc                                  # Main bash configuration
~/.bash_profile                            # Sources .bashrc
~/.config/starship.toml                    # Starship prompt config
~/.config/kind/                            # kind cluster configs
~/.config/kind/simple-cluster.yaml         # Simple cluster config
~/.config/kind/multi-node-cluster.yaml     # Multi-node config
~/.config/kind/advanced-cluster.yaml       # Advanced config
~/.config/kind/README.md                   # kind usage guide
```

### Installed Binaries
```
~/.local/bin/starship                      # Starship prompt
~/.local/bin/kubectl                       # Kubernetes CLI
~/.local/bin/kubectx                       # Context switcher
~/.local/bin/kubens                        # Namespace switcher
~/.local/bin/k9s                           # Terminal UI
~/.local/bin/kind                          # kind CLI (wrapper)
~/.local/bin/kind-binary                   # kind binary
```

### Documentation
```
~/docs/setup/SYSTEM_SETUP.md               # This file
~/docs/setup/AGENT_CONTEXT.md              # AI agent context
~/docs/setup/QUICK_REFERENCE.md            # Command quick reference
```

---

## Maintenance

### Updating Tools

#### Starship
```bash
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin
```

#### kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && mv kubectl ~/.local/bin/
```

#### kind
```bash
curl -Lo ~/.local/bin/kind-binary https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
chmod +x ~/.local/bin/kind-binary
```

#### kubectx & kubens
```bash
cd /tmp
curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx
curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens
chmod +x kubectx kubens && mv kubectx kubens ~/.local/bin/
```

#### k9s
```bash
cd /tmp
LATEST=$(curl -sS https://api.github.com/repos/derailed/k9s/releases/latest | grep "browser_download_url.*Linux_amd64.tar.gz" | cut -d '"' -f 4)
curl -LO "$LATEST"
tar xzf k9s_Linux_amd64.tar.gz k9s
mv k9s ~/.local/bin/
rm k9s_Linux_amd64.tar.gz
```

### Backing Up Configuration

```bash
# Backup all configs
tar czf ~/bash-k8s-backup-$(date +%Y%m%d).tar.gz \
  ~/.bashrc \
  ~/.bash_profile \
  ~/.config/starship.toml \
  ~/.config/kind/ \
  ~/docs/setup/

# Restore
tar xzf ~/bash-k8s-backup-YYYYMMDD.tar.gz -C ~/
source ~/.bashrc
```

### Syncing to macOS

1. **Copy configuration files:**
```bash
# On Linux
scp ~/.bashrc mac-machine:~/
scp ~/.config/starship.toml mac-machine:~/.config/
scp -r ~/.config/kind/ mac-machine:~/.config/
```

2. **Install tools on macOS:**
```bash
# On macOS
# Starship
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl && mv kubectl ~/.local/bin/

# kubectx & kubens
curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx
curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens
chmod +x kubectx kubens && mv kubectx kubens ~/.local/bin/

# k9s
curl -LO https://github.com/derailed/k9s/releases/download/v0.50.16/k9s_Darwin_amd64.tar.gz
tar xzf k9s_Darwin_amd64.tar.gz k9s && mv k9s ~/.local/bin/

# kind
curl -Lo ~/.local/bin/kind https://kind.sigs.k8s.io/dl/v0.26.0/kind-darwin-amd64
chmod +x ~/.local/bin/kind
```

3. **Apply configuration:**
```bash
source ~/.bashrc
```

### Troubleshooting

#### Starship not showing
```bash
# Check if starship is in PATH
which starship

# Reload config
source ~/.bashrc

# Check starship config
starship config
```

#### kubectl completion not working
```bash
# Reload bashrc
source ~/.bashrc

# Test completion manually
source <(kubectl completion bash)
```

#### kind can't connect to Docker
```bash
# Check Docker is running
docker ps

# Check user has Docker permissions
groups | grep docker

# If not in docker group
sudo usermod -aG docker $USER
newgrp docker
```

#### k9s shows error
```bash
# Check if kubectl can connect
kubectl cluster-info

# Check kubeconfig
kubectl config view

# Try with specific context
k9s --context kind-learning
```

---

## Additional Resources

- [Starship Documentation](https://starship.rs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [kind Documentation](https://kind.sigs.k8s.io/)
- [k9s Documentation](https://k9scli.io/)

---

**Last Updated:** 2025-11-08
**Maintained by:** yuandrk
