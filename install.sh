#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================
# Works on: macOS (Homebrew-first, zsh) and Linux (curl-based, bash/zsh)
#
# Usage:
#   ./install.sh              # Interactive installation
#   ./install.sh --all        # Install everything
#   ./install.sh --minimal    # Only dotfiles, no tools
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect OS
OS_TYPE="$(uname -s)"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# Helper Functions
# ============================================================================

print_header()  { echo -e "\n${BLUE}==>${NC} ${1}"; }
print_success() { echo -e "${GREEN}✓${NC} ${1}"; }
print_warning() { echo -e "${YELLOW}!${NC} ${1}"; }
print_error()   { echo -e "${RED}✗${NC} ${1}"; }

ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi

    read -p "$prompt" -n 1 -r
    echo

    if [ "$default" = "y" ]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

backup_file() {
    local file="$1"
    # Only back up real files/dirs, not symlinks we manage
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"
    backup_file "$target"
    # -n is essential: without it, re-running the installer on a directory
    # symlink follows the link and creates a nested copy inside it
    # (e.g. ~/.config/nvim/nvim) instead of replacing the link.
    ln -sfn "$source" "$target"
    print_success "Linked $target -> $source"
}

# ============================================================================
# Dotfiles (symlinks)
# ============================================================================

install_dotfiles() {
    print_header "Installing Dotfiles"

    # Zsh (primary shell on macOS)
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"

    # Bash (kept for Linux / `bash` sessions)
    create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    create_symlink "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"
    create_symlink "$DOTFILES_DIR/bash/inputrc" "$HOME/.inputrc"  # readline keys, like stock Linux

    # Starship
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

    # Ghostty terminal
    create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

    # Neovim
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Claude Code — link individual files only. ~/.claude also holds credentials
    # and session state, which must never be symlinked into a public repo.
    # settings.json is copied once, not linked: Claude Code writes machine-local
    # (and sometimes private) settings into it.
    mkdir -p "$HOME/.claude"
    if [ ! -e "$HOME/.claude/settings.json" ]; then
        cp "$DOTFILES_DIR/claude/settings.example.json" "$HOME/.claude/settings.json"
        print_success "Created ~/.claude/settings.json from settings.example.json"
    fi
    create_symlink "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

    # Documentation
    create_symlink "$DOTFILES_DIR/docs/setup" "$HOME/docs/setup"

    print_success "Dotfiles installed!"
}

# ============================================================================
# macOS: Homebrew-based tool installation
# ============================================================================

ensure_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew already installed"
        return 0
    fi

    print_warning "Homebrew not found."
    if ask_yes_no "Install Homebrew now?" "y"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Load brew into the current shell (Apple Silicon, then Intel)
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        print_error "Homebrew is required for the macOS tool install. Skipping tools."
        return 1
    fi
}

install_macos_tools() {
    print_header "Installing tools via Homebrew"

    ensure_homebrew || return 0

    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Homebrew tools installed"
}

# ============================================================================
# Linux: curl-based tool installation
# ============================================================================

# CPU architecture as release files spell it: linux_arch <x86_64-name> <arm64-name>
linux_arch() {
    case "$(uname -m)" in
        x86_64)        echo "$1" ;;
        aarch64|arm64) echo "$2" ;;
        *)             return 1 ;;
    esac
}

install_starship_linux() {
    print_header "Installing Starship"
    if command -v starship &> /dev/null; then
        print_warning "Starship already installed"; return
    fi
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    print_success "Starship installed"
}

install_kubectl_linux() {
    print_header "Installing kubectl"
    if command -v kubectl &> /dev/null; then
        print_warning "kubectl already installed"; return
    fi
    local arch; arch="$(linux_arch amd64 arm64)" || { print_warning "Unsupported CPU, skipping"; return; }
    local version; version="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
    curl -fsSL -o "$HOME/.local/bin/kubectl" "https://dl.k8s.io/release/${version}/bin/linux/${arch}/kubectl"
    chmod +x "$HOME/.local/bin/kubectl"
    print_success "kubectl ${version} installed"
}

install_k9s_linux() {
    print_header "Installing k9s"
    if command -v k9s &> /dev/null; then
        print_warning "k9s already installed"; return
    fi
    local arch; arch="$(linux_arch amd64 arm64)" || { print_warning "Unsupported CPU, skipping"; return; }
    curl -fsSL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${arch}.tar.gz" \
        | tar xz -C "$HOME/.local/bin" k9s
    print_success "k9s installed"
}

install_zmx_linux() {
    print_header "Installing zmx"
    if command -v zmx &> /dev/null; then
        print_warning "zmx already installed"; return
    fi
    local ZMX_VERSION="0.8.1"
    local arch; arch="$(linux_arch x86_64 aarch64)" || { print_warning "Unsupported CPU, skipping"; return; }
    curl -fsSL "https://zmx.sh/a/zmx-${ZMX_VERSION}-linux-${arch}.tar.gz" | tar xz -C "$HOME/.local/bin" zmx
    print_success "zmx ${ZMX_VERSION} installed"
}

install_neovim_linux() {
    print_header "Installing Neovim"
    if command -v nvim &> /dev/null; then
        print_warning "Neovim already installed: $(nvim --version | head -n 1)"; return
    fi
    # Latest stable release tarball (LazyVim needs a recent Neovim), unpacked
    # to ~/.local/nvim-linux-<arch> with a symlink in ~/.local/bin.
    local arch; arch="$(linux_arch x86_64 arm64)" || { print_warning "Unsupported CPU, skipping"; return; }
    rm -rf "$HOME/.local/nvim-linux-${arch}"
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz" \
        | tar xz -C "$HOME/.local"
    ln -sfn "$HOME/.local/nvim-linux-${arch}/bin/nvim" "$HOME/.local/bin/nvim"
    print_success "Neovim installed: $("$HOME/.local/bin/nvim" --version | head -n 1)"
    print_warning "Note: LazyVim plugins will install on first launch"
}

install_linux_tools() {
    mkdir -p "$HOME/.local/bin"
    install_starship_linux
    install_neovim_linux
    install_zmx_linux
    install_kubectl_linux
    install_k9s_linux
}

# ============================================================================
# Main
# ============================================================================

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                   DOTFILES INSTALLATION                       ║
║                                                               ║
║  Zsh + zmx + Starship + Neovim + Kubernetes Tools             ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo "Detected OS: $OS_TYPE ($(uname -m))"
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo
}

install_tools() {
    if [ "$OS_TYPE" = "Darwin" ]; then
        install_macos_tools
    else
        install_linux_tools
    fi
}

main() {
    show_banner

    local install_mode="${1:-interactive}"

    case "$install_mode" in
        --all)
            print_header "Installing everything..."
            install_dotfiles
            install_tools
            ;;
        --minimal)
            print_header "Installing dotfiles only..."
            install_dotfiles
            ;;
        *)
            if ask_yes_no "Install dotfiles (.zshrc, .inputrc, nvim, etc.)?" "y"; then
                install_dotfiles
            fi
            if ask_yes_no "Install tools (Starship, Neovim, zmx, Kubernetes toolkit)?" "y"; then
                install_tools
            fi
            ;;
    esac

    print_header "Installation Complete!"
    echo
    if [ "$OS_TYPE" = "Darwin" ]; then
        print_success "Open a new terminal (or run: source ~/.zshrc) to apply."
    else
        print_success "To apply changes, run: source ~/.zshrc  (or ~/.bashrc)"
    fi
    echo
    echo "Next steps:"
    echo "  1. Open a new terminal tab to load the prompt and aliases"
    echo "  2. Launch 'nvim' once so LazyVim installs its plugins"
    echo
    echo -e "${GREEN}Enjoy your enhanced development environment!${NC}"
}

main "$@"
