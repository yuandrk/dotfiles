# Brewfile — install everything with:  brew bundle --file=Brewfile
# Architecture-correct on Apple Silicon and Intel automatically (brew handles it).

# --- Shell / prompt ---
brew "starship"        # cross-shell prompt
cask "font-jetbrains-mono-nerd-font"  # Nerd Font for Starship glyphs (set in iTerm)
brew "tmux"            # terminal multiplexer
brew "neovim"          # editor (LazyVim config in nvim/)

# --- Kubernetes toolkit ---
brew "kubernetes-cli"  # provides `kubectl`
brew "kubectx"         # provides `kubectx` and `kubens`
brew "k9s"             # cluster TUI
brew "kind"            # local Kubernetes in Docker
brew "watch"           # used by the `kwp` helper (not built into macOS)

# --- Container runtime for kind (pick one) ---
brew "colima"          # lightweight Docker runtime, no Docker Desktop needed
brew "docker"          # docker CLI (talks to colima)
# Alternative: comment the two lines above and use Docker Desktop instead:
# cask "docker"

# --- 1Password ---
cask "1password-cli"   # `op` CLI: secrets, SSH agent, shell plugins
# On a fresh Mac, also install the desktop app (provides the SSH agent +
# biometric unlock). Skip / comment this if 1Password.app is already installed:
# cask "1password"

# --- Optional: modern bash (default shell stays zsh) ---
# brew "bash"
