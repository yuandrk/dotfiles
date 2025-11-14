# 🚀 Dotfiles

My personal dotfiles for a powerful, consistent shell environment across Linux and macOS.

**Enhanced Bash + Tmux + Starship Prompt + Kubernetes Toolkit**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-lightgrey.svg)

---

## ✨ Features

### 🐚 Enhanced Bash
- **Smart History**: 10,000 commands with timestamps, no duplicates
- **Auto-correction**: Typo correction for paths and commands
- **60+ Aliases**: Shortcuts for common operations (git, kubectl, navigation)
- **20+ Functions**: Useful helpers (mkcd, extract, kubernetes shortcuts)
- **Cross-platform**: Works on both Linux and macOS

### 🖥️ Tmux Terminal Multiplexer
- **Ctrl-a prefix**: Screen-like keybindings
- **Mouse support**: Easy pane/window selection and resizing
- **Vim-style navigation**: Navigate panes with hjkl
- **Intuitive splits**: | for vertical, - for horizontal
- **Modern status bar**: Clean design with session info and time
- **Smart copy mode**: Vim keybindings for text selection

### 🎨 Starship Prompt
- Beautiful, fast, and informative prompt
- Shows: git status, k8s context, language versions, execution time
- Pastel Powerline theme
- Highly customizable

### ☸️ Kubernetes Toolkit
- **kubectl** with full bash completion
- **kubectx/kubens** for fast context/namespace switching
- **k9s** terminal UI for cluster management
- **kind** for local Kubernetes testing
- **60+ kubectl aliases** and helper functions

### 📦 What's Included

```
dotfiles/
├── bash/
│   ├── bashrc              # Main bash configuration
│   └── bash_profile        # Bash profile
├── tmux/
│   └── tmux.conf           # Tmux configuration
├── starship/
│   └── starship.toml       # Starship prompt config
├── kind/
│   ├── simple-cluster.yaml
│   ├── multi-node-cluster.yaml
│   ├── advanced-cluster.yaml
│   └── README.md
├── docs/
│   └── setup/
│       ├── SYSTEM_SETUP.md      # Complete documentation
│       ├── QUICK_REFERENCE.md   # Command reference
│       ├── AGENT_CONTEXT.md     # AI assistant context
│       └── CHEATSHEET.txt       # Printable cheatsheet
├── install.sh              # Installation script
├── .gitignore              # Protects secrets
└── README.md               # This file
```

---

## 🚀 Quick Start

### Prerequisites
- **Bash** 4.0+ (usually pre-installed)
- **curl** (for downloading tools)
- **git** (for cloning this repo)
- **Docker** (optional, for kind)

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles
./install.sh

# Reload your shell
source ~/.bashrc
```

The installer will:
1. Backup existing dotfiles (`.bashrc.backup.TIMESTAMP`)
2. Create symlinks to your home directory
3. Optionally install tools (Starship, kubectl, k9s, kind)
4. Set up documentation

### Installation Options

```bash
./install.sh              # Interactive (recommended)
./install.sh --all        # Install everything without prompts
./install.sh --minimal    # Only install dotfiles, skip tools
```

---

## 📚 Quick Reference

### Shell Aliases

```bash
# Navigation
..              # cd ..
...             # cd ../..
ll              # ls -lh (detailed)
la              # ls -lhA (include hidden)

# Git
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git log --graph

# Utilities
mkcd <dir>      # Create directory and cd into it
extract <file>  # Auto-extract any archive
ff <pattern>    # Find files
path            # Show PATH nicely
```

### Kubernetes Aliases

```bash
# Basic
k               # kubectl
kgp             # kubectl get pods
kgs             # kubectl get svc
kgd             # kubectl get deployments
kgn             # kubectl get nodes

# Logs & Debug
kl <pod>        # kubectl logs
klf <pod>       # kubectl logs -f (follow)
kshell <pod>    # Open shell in pod
kbash <pod>     # Open bash in pod

# Context & Namespace
kctx            # Switch context (kubectx)
kns             # Switch namespace (kubens)

# Helper Functions
kgpw <pattern>  # Find pods by name
kwp             # Watch pods
kevents         # Get events sorted by time
kpf <pod> <port> # Port forward
ktop            # Resource usage
```

### kind (Local Kubernetes)

```bash
kind-new <name>         # Create cluster
kind-multi [name]       # Create multi-node cluster
kind-with-ports [name]  # Create cluster with port mappings
kind-list               # List all clusters
kind-clean              # Delete all clusters
kind-img <image>        # Load Docker image into cluster
```

### Tmux

```bash
# Sessions
tmux                    # Start new session
tmux new -s <name>      # Start named session
tmux ls                 # List sessions
tmux attach -t <name>   # Attach to session
tmux kill-session -t <name>  # Kill session

# Keybindings (prefix = Ctrl-a)
Ctrl-a |                # Split vertically
Ctrl-a -                # Split horizontally
Ctrl-a h/j/k/l          # Navigate panes (vim-style)
Alt-Arrow               # Navigate panes (arrow keys)
Ctrl-a H/J/K/L          # Resize panes
Ctrl-a c                # New window
Shift-Left/Right        # Switch windows
Ctrl-a d                # Detach from session
Ctrl-a [                # Enter copy mode (vim keys)
Ctrl-a S                # Sync panes (broadcast to all)
Ctrl-a ?                # Show all keybindings
```

---

## 📖 Documentation

All documentation is available in `docs/setup/`:

- **[SYSTEM_SETUP.md](docs/setup/SYSTEM_SETUP.md)** - Complete system documentation
- **[QUICK_REFERENCE.md](docs/setup/QUICK_REFERENCE.md)** - Command reference
- **[AGENT_CONTEXT.md](docs/setup/AGENT_CONTEXT.md)** - AI assistant context
- **[CHEATSHEET.txt](docs/setup/CHEATSHEET.txt)** - Printable cheatsheet

Quick access:
```bash
cat ~/docs/setup/QUICK_REFERENCE.md
cat ~/docs/setup/CHEATSHEET.txt
```

---

## 🎯 Common Workflows

### Learning Kubernetes with kind

```bash
# Create a learning cluster
kind-new learning

# Deploy something
k create deployment nginx --image=nginx
k expose deployment nginx --port=80

# Explore with k9s
k9s

# Clean up
kind delete cluster --name learning
```

### Testing Kubernetes Manifests

```bash
# Create test cluster
kind-new test

# Apply manifests
k apply -f deployment.yaml

# Check status
kgp
klf <pod-name>

# Debug
k9s

# Clean up
kind delete cluster --name test
```

---

## 🔧 Customization

### Bashrc
Edit `bash/bashrc` to add your own aliases and functions.

### Starship Prompt
Edit `starship/starship.toml` or try different presets:

```bash
starship preset --list
starship preset <preset-name> -o ~/.config/starship.toml
```

### kind Configs
Add your own cluster configs to `kind/` directory and use with:

```bash
kind create cluster --config ~/dotfiles/kind/my-config.yaml
```

---

## 🌍 Multi-Machine Setup

### Syncing to Another Machine

```bash
# On the new machine
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

That's it! The installer handles platform differences (Linux vs macOS).

### Updating

```bash
cd ~/dotfiles
git pull
./install.sh --minimal  # Re-link dotfiles
source ~/.bashrc
```

---

## 🛠️ Tools Installed

| Tool | Version | Purpose |
|------|---------|---------|
| [Starship](https://starship.rs/) | v1.24.0 | Cross-shell prompt |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | v1.34.1 | Kubernetes CLI |
| [kubectx/kubens](https://github.com/ahmetb/kubectx) | v0.9.5 | Context/namespace switcher |
| [k9s](https://k9scli.io/) | v0.50.16 | Terminal UI for Kubernetes |
| [kind](https://kind.sigs.k8s.io/) | v0.26.0 | Kubernetes in Docker |

All tools are installed to `~/.local/bin/` (no sudo required).

---

## 🤝 For AI Assistants

This repository includes `docs/setup/AGENT_CONTEXT.md` which provides context for AI coding assistants (Claude Code, GitHub Copilot, etc.) to understand this environment.

Key points:
- Environment is optimized for Kubernetes learning/testing
- Many custom aliases and functions are available
- kind is preferred for local testing
- User may be in a flatpak environment

---

## 🔒 Security

This repository is designed to be **public-safe**:
- Comprehensive `.gitignore` to prevent secret commits
- No SSH keys, credentials, or tokens
- No sensitive kubeconfig data
- Local machine-specific configs excluded

**Before committing changes:**
```bash
# Check for potential secrets
grep -r "password\|token\|secret\|key" . --exclude-dir=.git

# Review what will be committed
git diff --cached
```

---

## 🐛 Troubleshooting

### Dotfiles not loading
```bash
source ~/.bashrc
```

### kubectl completion not working
```bash
source <(kubectl completion bash)
```

### kind can't connect to Docker
```bash
# Check Docker
docker ps

# Add user to docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker
```

### Starship not showing
```bash
# Check installation
which starship

# Reload
source ~/.bashrc
```

---

## 📝 License

MIT License - Feel free to use and modify!

---

## 🙏 Acknowledgments

- [Starship](https://starship.rs/) - Amazing prompt
- [kubectx/kubens](https://github.com/ahmetb/kubectx) - Essential kubectl tools
- [k9s](https://k9scli.io/) - Best k8s TUI
- [kind](https://kind.sigs.k8s.io/) - Local k8s testing

---

## 📬 Contact

Feel free to open issues or submit PRs!

---

**Happy coding! 🚀**
