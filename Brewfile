# Brewfile — install everything with:  brew bundle --file=Brewfile
# Architecture-correct on Apple Silicon and Intel automatically (brew handles it).

# --- Taps (must precede the tapped formulae below) ---
tap "hashicorp/tap"
tap "fluxcd/tap"
tap "neurosnap/tap"

# --- Terminal / shell / prompt ---
cask "ghostty"         # terminal emulator (config in ghostty/config)
brew "starship"        # cross-shell prompt
cask "font-jetbrains-mono-nerd-font"  # Nerd Font for Starship glyphs (set in ghostty/config)
brew "neurosnap/tap/zmx" # session persistence (attach/detach); no panes
brew "tmux"            # panes/windows/splits only — sessions use zmx
brew "neovim"          # editor (LazyVim config in nvim/)

# --- Kubernetes toolkit ---
brew "kubernetes-cli"  # provides `kubectl`
brew "k9s"             # cluster TUI
brew "kind"            # local Kubernetes in Docker

# --- Container runtime for kind ---
# Docker Desktop, installed manually (/Applications/Docker.app); it ships the
# docker CLI in ~/.docker/bin. On a fresh Mac:  brew install --cask docker-desktop

# --- 1Password ---
cask "1password-cli"   # `op` CLI: secrets, SSH agent, shell plugins
# On a fresh Mac, also install the desktop app (provides the SSH agent +
# biometric unlock). Skip / comment this if 1Password.app is already installed:
# cask "1password"

# --- Git / GitHub ---
brew "gh"              # `gh pr`, `gh repo`, GitHub auth

# --- Infrastructure as code ---
brew "hashicorp/tap/terraform"
brew "helm"            # Kubernetes package manager
brew "fluxcd/tap/flux" # GitOps CLI
brew "sops"            # encrypted secrets in git
brew "age"             # modern encryption backend for sops
brew "terraform-docs"  # generate docs for Terraform modules
# tflint is not in Homebrew — standalone binary in ~/.local/bin
# (https://github.com/terraform-linters/tflint/releases)

# --- Networking ---
brew "cloudflared"     # Cloudflare Tunnel client

# --- CLI utilities ---
brew "yq"              # jq for YAML (jq itself ships with macOS at /usr/bin/jq)
brew "ripgrep"         # `rg` — used by LazyVim/telescope and Claude Code search
brew "btop"            # resource monitor
brew "ffmpeg"          # audio/video conversion
brew "mole"            # macOS cleanup (`mole` / `mo`)
brew "syncthing"       # file sync; runs as a service (brew services start syncthing)

# --- Languages / runtimes ---
brew "node"
brew "uv"              # Python package/venv manager

# --- AI coding tools ---
# Claude Code is NOT installed via brew — it self-installs to ~/.local/bin/claude
# and self-updates. Config lives in claude/ (see CLAUDE.md).

# --- Optional: modern bash (default shell stays zsh) ---
# brew "bash"
