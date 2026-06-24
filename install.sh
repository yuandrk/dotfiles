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
    ln -sf "$source" "$target"
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

    # Tmux
    create_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Starship
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

    # Ghostty terminal
    create_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

    # kind configs
    create_symlink "$DOTFILES_DIR/kind" "$HOME/.config/kind"

    # Neovim
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

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

    print_header "Container runtime for kind"
    print_warning "kind needs a Docker engine. Using colima (installed above):"
    echo "    colima start              # start the Docker VM"
    echo "    docker ps                 # verify it works"
    echo "  Or install Docker Desktop instead."
}

# ============================================================================
# Linux: curl-based tool installation
# ============================================================================

install_starship_linux() {
    print_header "Installing Starship"
    if command -v starship &> /dev/null; then
        print_warning "Starship already installed"; return
    fi
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    print_success "Starship installed"
}

install_kubectl_linux() {
    print_header "Installing kubectl"
    if command -v kubectl &> /dev/null; then
        print_warning "kubectl already installed"; return
    fi
    mkdir -p "$HOME/.local/bin"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl "$HOME/.local/bin/"
    print_success "kubectl installed"
}

install_kubectx_kubens_linux() {
    print_header "Installing kubectx and kubens"
    if command -v kubectx &> /dev/null && command -v kubens &> /dev/null; then
        print_warning "kubectx and kubens already installed"; return
    fi
    mkdir -p "$HOME/.local/bin"
    curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx
    curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens
    chmod +x kubectx kubens
    mv kubectx kubens "$HOME/.local/bin/"
    print_success "kubectx and kubens installed"
}

install_k9s_linux() {
    print_header "Installing k9s"
    if command -v k9s &> /dev/null; then
        print_warning "k9s already installed"; return
    fi
    mkdir -p "$HOME/.local/bin"
    cd /tmp
    curl -LO https://github.com/derailed/k9s/releases/download/v0.50.16/k9s_Linux_amd64.tar.gz
    tar xzf k9s_Linux_amd64.tar.gz k9s
    rm k9s_Linux_amd64.tar.gz
    mv k9s "$HOME/.local/bin/"
    cd - > /dev/null
    print_success "k9s installed"
}

install_kind_linux() {
    print_header "Installing kind"
    if command -v kind &> /dev/null || [ -f "$HOME/.local/bin/kind-binary" ]; then
        print_warning "kind already installed"; return
    fi
    mkdir -p "$HOME/.local/bin"

    if [ -n "$FLATPAK_ID" ]; then
        print_warning "Detected flatpak environment - installing with wrapper"
        curl -Lo "$HOME/.local/bin/kind-binary" https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
        chmod +x "$HOME/.local/bin/kind-binary"
        cat > "$HOME/.local/bin/kind" << 'EOF'
#!/usr/bin/env bash
TEMP_BIN=$(mktemp -d)
trap "rm -rf $TEMP_BIN" EXIT
cat > "$TEMP_BIN/docker" << 'DOCKER_WRAPPER'
#!/usr/bin/env bash
exec /usr/bin/flatpak-spawn --host docker "$@"
DOCKER_WRAPPER
chmod +x "$TEMP_BIN/docker"
PATH="$TEMP_BIN:$PATH" ~/.local/bin/kind-binary "$@"
EOF
        chmod +x "$HOME/.local/bin/kind"
    else
        curl -Lo "$HOME/.local/bin/kind" https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
        chmod +x "$HOME/.local/bin/kind"
    fi
    print_success "kind installed"
}

install_neovim_linux() {
    print_header "Installing Neovim"
    if command -v nvim &> /dev/null; then
        print_warning "Neovim already installed: $(nvim --version | head -n 1)"; return
    fi
    mkdir -p "$HOME/.local/bin"
    local NVIM_VERSION="v0.10.2"
    cd /tmp
    rm -f nvim.appimage
    if command -v wget &> /dev/null; then
        wget -q --show-progress "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
    else
        curl -L "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage" -o nvim.appimage
    fi
    chmod +x nvim.appimage
    if ./nvim.appimage --version &> /dev/null; then
        mv nvim.appimage "$HOME/.local/bin/nvim"
        print_success "Neovim installed (AppImage)"
    else
        print_warning "AppImage FUSE not available, extracting instead..."
        ./nvim.appimage --appimage-extract > /dev/null
        rm -rf "$HOME/.local/nvim"
        mv squashfs-root "$HOME/.local/nvim"
        ln -sf "$HOME/.local/nvim/usr/bin/nvim" "$HOME/.local/bin/nvim"
        print_success "Neovim installed (extracted)"
    fi
    cd - > /dev/null
    print_warning "Note: LazyVim plugins will install on first launch"
}

check_docker_linux() {
    print_header "Checking Docker"
    if ! command -v docker &> /dev/null; then
        print_warning "Docker not found. kind requires Docker."
        print_warning "Install: https://docs.docker.com/engine/install/"
        return 1
    fi
    if ! docker ps &> /dev/null; then
        print_warning "Docker is installed but not accessible. You may need to:"
        print_warning "  sudo systemctl start docker"
        print_warning "  sudo usermod -aG docker \$USER  (then log out/in)"
        return 1
    fi
    print_success "Docker is available"
}

install_linux_tools() {
    install_starship_linux
    install_neovim_linux
    install_kubectl_linux
    install_kubectx_kubens_linux
    install_k9s_linux
    install_kind_linux
    check_docker_linux || true
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
║  Zsh + Tmux + Starship + Neovim + Kubernetes Tools            ║
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
            if ask_yes_no "Install dotfiles (.zshrc, .tmux.conf, nvim, etc.)?" "y"; then
                install_dotfiles
            fi
            if ask_yes_no "Install tools (Starship, Neovim, Kubernetes toolkit)?" "y"; then
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
    echo "  3. For kind: start a Docker engine (colima start) and run 'kind-new'"
    echo
    echo -e "${GREEN}Enjoy your enhanced development environment!${NC}"
}

main "$@"
