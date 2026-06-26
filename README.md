# 🚀 Dotfiles

My personal dotfiles for a powerful, consistent shell environment across Linux and macOS.

**Zsh (+ Bash) + Tmux + Neovim (LazyVim) + Starship Prompt + Kubernetes Toolkit**

> On **macOS** the install is Homebrew-first and targets the default **zsh** shell.
> On **Linux** it falls back to curl-based installs and keeps the bash config.

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

### 👻 Ghostty Terminal
- Fast, GPU-accelerated terminal emulator (replaces a manually-configured iTerm2)
- Config tracked at `ghostty/config`, symlinked to `~/.config/ghostty/config`
- JetBrainsMono Nerd Font preset for Starship glyphs
- Color scheme ported directly from the previous iTerm2 profile

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

### ⚡ Neovim with LazyVim
- **Modern IDE-like experience**: LSP, autocompletion, syntax highlighting
- **LazyVim**: Pre-configured with sensible defaults and 40+ plugins
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Telescope**: Fuzzy finder for files, text, and more
- **Neo-tree**: File explorer with git integration
- **LazyGit**: Git integration directly in Neovim
- **Easy customization**: Add your own plugins in lua/plugins/
- **Fast startup**: Lazy-loaded plugins for optimal performance

### ☸️ Kubernetes Toolkit
- **kubectl** with full bash completion
- **kubectx/kubens** for fast context/namespace switching
- **k9s** terminal UI for cluster management
- **kind** for local Kubernetes testing
- **60+ kubectl aliases** and helper functions

### 📦 What's Included

```
dotfiles/
├── zsh/
│   ├── zshrc               # Main zsh configuration (macOS default)
│   └── zprofile            # Login shell: Homebrew env + PATH
├── bash/
│   ├── bashrc              # Bash configuration (Linux / `bash` sessions)
│   └── bash_profile        # Bash profile
├── Brewfile                # macOS tool list (brew bundle)
├── tmux/
│   └── tmux.conf           # Tmux configuration
├── nvim/
│   ├── init.lua            # Neovim entry point
│   ├── lua/
│   │   ├── config/         # Options, keymaps, autocmds
│   │   └── plugins/        # Custom plugins
│   └── README.md           # Neovim documentation
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
- **git** (for cloning this repo)
- **macOS:** [Homebrew](https://brew.sh) — the installer offers to install it for you if missing
- **Linux:** `curl` (tools are downloaded directly)
- **Docker engine** (optional, for kind — `colima` on macOS, or Docker Desktop)

### Installation (macOS)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installer (installs Homebrew if needed, then everything via brew bundle)
cd ~/dotfiles
./install.sh

# Open a new terminal, or reload the shell
source ~/.zshrc
```

Or install just the tools yourself:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

The installer will:
1. Back up any existing real dotfiles (`.zshrc.backup.TIMESTAMP`) — existing symlinks are replaced silently
2. Symlink `.zshrc`, `.zprofile`, `.tmux.conf`, nvim, starship, kind configs into place
3. On macOS, install all tools via Homebrew (`Brewfile`); on Linux, download them with curl
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

### Neovim (LazyVim)

```bash
# Launch
nvim                    # Start Neovim
nvim <file>             # Open file

# Essential Keybindings (Leader = Space)
Space-e                 # Toggle file explorer
Space-ff                # Find files
Space-fg                # Find text (grep)
Space-Space             # Command palette
Space-w                 # Save file
Ctrl-s                  # Save file (insert/normal mode)
Space-qq                # Quit all

# Window/Buffer Management
Space-sv                # Split vertically
Space-sh                # Split horizontally
Shift-h                 # Previous buffer
Shift-l                 # Next buffer
jk                      # Exit insert mode

# Plugin Management
:Lazy                   # Open plugin manager
:LazyExtras             # Browse language support extras
:Mason                  # LSP/formatter/linter installer

# Documentation
cat ~/.config/nvim/README.md  # Full guide
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

### Neovim
Add custom plugins in `nvim/lua/plugins/`:

```lua
-- nvim/lua/plugins/mycustom.lua
return {
  {
    "plugin-author/plugin-name",
    opts = {
      -- configuration
    },
  },
}
```

Full customization guide: `cat ~/.config/nvim/README.md`

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
source ~/.zshrc
```

---

## 🛠️ Tools Installed

| Tool | Version | Purpose |
|------|---------|---------|
| [Ghostty](https://ghostty.org/) | Latest | GPU-accelerated terminal emulator |
| [Neovim](https://neovim.io/) | Latest | Modern modal editor |
| [LazyVim](https://www.lazyvim.org/) | Latest | Neovim distribution |
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
source ~/.zshrc   # bash: source ~/.bashrc
```

### kubectl completion not working
```bash
source <(kubectl completion zsh)   # bash: kubectl completion bash
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

- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [LazyVim](https://www.lazyvim.org/) - Excellent Neovim starter configuration
- [Starship](https://starship.rs/) - Amazing prompt
- [kubectx/kubens](https://github.com/ahmetb/kubectx) - Essential kubectl tools
- [k9s](https://k9scli.io/) - Best k8s TUI
- [kind](https://kind.sigs.k8s.io/) - Local k8s testing

---

## 📬 Contact

Feel free to open issues or submit PRs!

---

**Happy coding! 🚀**
