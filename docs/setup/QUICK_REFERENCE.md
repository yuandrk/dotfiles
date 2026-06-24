# Quick Reference Guide

**Quick access to all custom commands, aliases, and functions**

---

## General Shell Aliases

```bash
# Navigation
..              # cd ..
...             # cd ../..
....            # cd ../../..
~               # cd ~

# File Operations
ll              # ls -lh (detailed list)
la              # ls -lhA (include hidden)
rm              # rm -i (interactive)
cp              # cp -i (interactive)
mv              # mv -i (interactive)
mkdir           # mkdir -pv (create parents, verbose)

# Utilities
h               # history
j               # jobs -l
path            # Show PATH nicely
now             # Current time
nowdate         # Current date (YYYY-MM-DD)
```

## Git Aliases

```bash
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git log --oneline --graph --decorate
gd              # git diff
```

## General Functions

```bash
mkcd <dir>                  # Create directory and cd into it
extract <file>              # Auto-extract any archive type
ff <pattern>                # Find files by name
fd <pattern>                # Find directories by name
```

---

## Terminal - Ghostty + Tmux

Ghostty boots straight into a shared tmux session named `main` (config:
`ghostty/config`). Reopening Ghostty reattaches to it; after a reboot,
tmux-continuum restores the previous windows, panes, layouts and nvim sessions.

```text
# Ghostty → tmux keybinds (macOS Cmd shortcuts that drive tmux)
Cmd+T                       # new tmux window        (prefix c)
Cmd+W                       # close current pane     (prefix x — asks y/n)
Cmd+D                       # split right            (prefix | )
Cmd+Shift+D                 # split down             (prefix - )
Cmd+1 .. Cmd+9              # jump to tmux window N   (prefix N)
Cmd+Q                       # quit Ghostty itself (not a tmux pane)

# Tmux session persistence (tmux-resurrect + tmux-continuum)
prefix + Ctrl-s             # save session now
prefix + Ctrl-r             # restore last saved session
                           # (auto-saves every 15 min; auto-restores on start)
```

Plugins are installed by `install.sh` (clones `tpm`, then runs its
`install_plugins`). To install by hand: open tmux and press `prefix + I`.

---

## Kubernetes - kubectl Aliases

### Get Resources
```bash
k               # kubectl
kgp             # kubectl get pods
kgs             # kubectl get svc
kgd             # kubectl get deployments
kgn             # kubectl get nodes
kga             # kubectl get all
kgpa            # kubectl get pods --all-namespaces
```

### Describe Resources
```bash
kdp             # kubectl describe pod
kds             # kubectl describe svc
kdd             # kubectl describe deployment
kdn             # kubectl describe node
```

### Other Operations
```bash
kdel            # kubectl delete
kl              # kubectl logs
klf             # kubectl logs -f
kex             # kubectl exec -it
kap             # kubectl apply -f
kdelp           # kubectl delete pod
```

### Context & Namespace
```bash
kctx            # kubectx (switch context)
kns             # kubens (switch namespace)
kgc             # kubectl config get-contexts
kcc             # kubectl config current-context
```

## Kubernetes - Helper Functions

```bash
# Pod Access
kshell <pod> [container]           # Open shell in pod
kbash <pod> [container]            # Open bash in pod

# Pod Operations
kgpw <pattern>                     # Find pods by name pattern
kwp                                # Watch pods (refreshes every 2s)
kevents                            # Get events sorted by time

# Port Forwarding
kpf <pod> <port>                   # Port forward to pod

# Resource Monitoring
ktop [pods|nodes]                  # Show resource usage

# Deployments
krestart <deployment>              # Restart deployment
```

### Examples
```bash
kgpw nginx                         # Find nginx pods
kshell my-pod-123                  # Shell into pod
kbash my-pod-123 my-container      # Bash into specific container
kpf my-pod 8080                    # Forward port 8080
ktop pods                          # Show pod resource usage
krestart my-deployment             # Restart deployment
```

---

## kind - Local Kubernetes

### Aliases
```bash
kind-create     # kind create cluster
kind-delete     # kind delete cluster
kind-list       # kind get clusters
kind-load       # kind load docker-image
```

### Functions
```bash
# Cluster Creation
kind-new <name>                    # Create cluster with custom name
kind-multi [name]                  # Create multi-node cluster (1 cp + 2 workers)
kind-with-ports [name]             # Create cluster with port mappings

# Cluster Management
kind-clean                         # Delete ALL kind clusters
kind-use <name>                    # Switch to kind cluster context
kind-nodes [cluster]               # Show nodes in cluster

# Image Management
kind-img <image> [cluster]         # Load Docker image into cluster
```

### Examples
```bash
kind-new learning                  # Create "learning" cluster
kind-multi test                    # Create multi-node "test" cluster
kind-with-ports web                # Create cluster with ports 80,443,30000

kind-img nginx:latest              # Load nginx into default cluster
kind-img my-app:v1 learning        # Load my-app into "learning" cluster

kind-nodes learning                # Show nodes in "learning" cluster
kind-use learning                  # Switch to "learning" cluster
kind-clean                         # Delete all clusters
```

### Quick Cluster Configs
```bash
# Use pre-made configs
kind create cluster --config ~/.config/kind/simple-cluster.yaml
kind create cluster --config ~/.config/kind/multi-node-cluster.yaml
kind create cluster --config ~/.config/kind/advanced-cluster.yaml
```

---

## k9s - Terminal UI

### Launch
```bash
k9s                                # Launch k9s
k9s -n <namespace>                 # Launch in specific namespace
k9s --context <context>            # Launch with specific context
```

### Key Bindings (inside k9s)
```
:                   # Command mode
/                   # Filter mode
?                   # Help
Ctrl+a              # Show all namespaces
0                   # Show all pods
1                   # Show all deployments
2                   # Show all services
d                   # Describe resource
l                   # Show logs
Ctrl+d              # Delete resource
Esc                 # Back
Ctrl+c              # Exit
```

---

## Starship Prompt

### Commands
```bash
starship preset --list             # List available presets
starship preset <name> -o ~/.config/starship.toml  # Apply preset
starship config                    # Validate config
starship explain                   # Explain current prompt
```

### What the Prompt Shows
- Username and hostname (colored)
- Current directory (smart truncation)
- Git branch and status
- Kubernetes context and namespace
- Language versions (Node, Python, Go, etc.)
- Docker context
- Command execution time
- Current time

---

## Common Workflows

### Learning k8s with kind
```bash
# 1. Create cluster
kind-new learning

# 2. Deploy something
k create deployment nginx --image=nginx
k expose deployment nginx --port=80

# 3. Check it
kgp
kgs
k9s

# 4. Clean up
kind delete cluster --name learning
```

### Testing a Deployment
```bash
# 1. Create test cluster
kind-new test

# 2. Apply manifests
k apply -f deployment.yaml

# 3. Check status
kgp
klf <pod-name>

# 4. Debug if needed
k9s
# or
kshell <pod-name>

# 5. Clean up
kind delete cluster --name test
```

### Multi-Node Cluster Testing
```bash
# 1. Create multi-node cluster
kind-multi advanced

# 2. Check nodes
kgn
kind-nodes advanced

# 3. Deploy with replicas
k create deployment web --image=nginx --replicas=3

# 4. See pod distribution
k get pods -o wide

# 5. Clean up
kind delete cluster --name advanced
```

### Working with Custom Images
```bash
# 1. Build image
docker build -t my-app:v1 .

# 2. Create cluster
kind-new dev

# 3. Load image
kind-img my-app:v1 dev

# 4. Deploy
k create deployment my-app --image=my-app:v1
k set image deployment/my-app my-app=my-app:v1

# 5. Verify
kgp
k9s
```

---

## File Locations

### Config Files
```
~/.bashrc                          # Bash configuration
~/.config/starship.toml            # Starship config
~/.config/kind/*.yaml              # kind cluster configs
```

### Documentation
```
~/docs/setup/SYSTEM_SETUP.md       # Full system documentation
~/docs/setup/AGENT_CONTEXT.md      # AI agent context
~/docs/setup/QUICK_REFERENCE.md    # This file
~/.config/kind/README.md           # kind usage guide
```

### Binaries
```
~/.local/bin/starship              # All tools installed here
~/.local/bin/kubectl
~/.local/bin/kubectx
~/.local/bin/kubens
~/.local/bin/k9s
~/.local/bin/kind
```

---

## Useful One-Liners

### Kubernetes
```bash
# Get all resources in namespace
k api-resources --verbs=list --namespaced -o name | xargs -n 1 k get --show-kind --ignore-not-found -n <namespace>

# Get pods sorted by restart count
k get pods --sort-by='.status.containerStatuses[0].restartCount'

# Get pods sorted by CPU
k top pods --sort-by=cpu

# Get pods sorted by memory
k top pods --sort-by=memory

# Watch pod creation
watch -n 1 kubectl get pods

# Get events for a pod
k get events --field-selector involvedObject.name=<pod-name>

# Get container image for all pods
k get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.containers[*].image}{"\n"}{end}'
```

### kind
```bash
# Get all kind clusters
docker ps --filter "label=io.x-k8s.kind.cluster"

# Get kubeconfig for kind cluster
kind get kubeconfig --name <cluster-name>

# Export kind cluster config
kind export kubeconfig --name <cluster-name>

# List kind node images
docker images | grep kindest/node
```

### Shell
```bash
# Find large files
find . -type f -size +100M -exec ls -lh {} \;

# Find recently modified files
find . -type f -mtime -7 -ls

# Disk usage of directories
du -h --max-depth=1 | sort -hr

# Show all bash functions
declare -F

# Show all bash aliases
alias
```

---

## Troubleshooting

### Reload Configuration
```bash
source ~/.bashrc
```

### Check Tool Versions
```bash
starship --version
kubectl version --client
kind version
k9s version
docker --version
```

### Docker Permissions (on host)
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### kubectl Not Connecting
```bash
k cluster-info
k config view
k config get-contexts
kctx  # List and switch contexts
```

### kind Issues
```bash
kind get clusters                  # List clusters
docker ps                          # Check kind containers
kind delete clusters --all         # Nuclear option
```

---

## Tips & Tricks

1. **Use tab completion**: All kubectl commands have completion enabled
2. **Use k9s for exploration**: Visual interface is great for learning
3. **Test in kind first**: Always test deployments locally before production
4. **Use kubectx/kubens**: Fast context/namespace switching
5. **Watch with kwp**: Better than `watch kubectl get pods`
6. **Filter k9s output**: Use `/` in k9s to filter resources
7. **Use kgpw for search**: Find pods by partial name
8. **Check Starship**: It shows your k8s context, no need to guess
9. **Use helper functions**: They save typing and are tested
10. **Read the logs with klf**: Follow mode is your friend

---

**Quick Access:**
- Full docs: `cat ~/docs/setup/SYSTEM_SETUP.md`
- Agent context: `cat ~/docs/setup/AGENT_CONTEXT.md`
- kind examples: `cat ~/.config/kind/README.md`

**Last Updated:** 2025-11-08
