#!/usr/bin/env bash

# ============================================================================
# Dotfiles Installation Script
# ============================================================================
# This script installs dotfiles and required tools
# Works on: Linux (tested on Fedora) and macOS
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

print_header() {
    echo -e "\n${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}!${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

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
    if [ -f "$file" ] || [ -d "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing $file to $backup"
        mv "$file" "$backup"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Backup existing file/dir
    backup_file "$target"

    # Create symlink
    ln -sf "$source" "$target"
    print_success "Linked $target -> $source"
}

# ============================================================================
# Installation Functions
# ============================================================================

install_dotfiles() {
    print_header "Installing Dotfiles"

    # Bash
    create_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
    create_symlink "$DOTFILES_DIR/bash/bash_profile" "$HOME/.bash_profile"

    # Starship
    mkdir -p "$HOME/.config"
    create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

    # kind configs
    create_symlink "$DOTFILES_DIR/kind" "$HOME/.config/kind"

    # Documentation
    create_symlink "$DOTFILES_DIR/docs/setup" "$HOME/docs/setup"

    print_success "Dotfiles installed!"
}

install_starship() {
    print_header "Installing Starship"

    if command -v starship &> /dev/null; then
        print_warning "Starship already installed"
        return
    fi

    mkdir -p "$HOME/.local/bin"

    if [ "$OS_TYPE" = "Darwin" ]; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    else
        curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
    fi

    print_success "Starship installed"
}

install_kubectl() {
    print_header "Installing kubectl"

    if command -v kubectl &> /dev/null; then
        print_warning "kubectl already installed"
        return
    fi

    mkdir -p "$HOME/.local/bin"

    if [ "$OS_TYPE" = "Darwin" ]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
    else
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    fi

    chmod +x kubectl
    mv kubectl "$HOME/.local/bin/"

    print_success "kubectl installed"
}

install_kubectx_kubens() {
    print_header "Installing kubectx and kubens"

    if command -v kubectx &> /dev/null && command -v kubens &> /dev/null; then
        print_warning "kubectx and kubens already installed"
        return
    fi

    mkdir -p "$HOME/.local/bin"

    curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx
    curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubens

    chmod +x kubectx kubens
    mv kubectx kubens "$HOME/.local/bin/"

    print_success "kubectx and kubens installed"
}

install_k9s() {
    print_header "Installing k9s"

    if command -v k9s &> /dev/null; then
        print_warning "k9s already installed"
        return
    fi

    mkdir -p "$HOME/.local/bin"

    cd /tmp

    if [ "$OS_TYPE" = "Darwin" ]; then
        curl -LO https://github.com/derailed/k9s/releases/download/v0.50.16/k9s_Darwin_amd64.tar.gz
        tar xzf k9s_Darwin_amd64.tar.gz k9s
        rm k9s_Darwin_amd64.tar.gz
    else
        curl -LO https://github.com/derailed/k9s/releases/download/v0.50.16/k9s_Linux_amd64.tar.gz
        tar xzf k9s_Linux_amd64.tar.gz k9s
        rm k9s_Linux_amd64.tar.gz
    fi

    mv k9s "$HOME/.local/bin/"
    cd - > /dev/null

    print_success "k9s installed"
}

install_kind() {
    print_header "Installing kind"

    if command -v kind &> /dev/null || [ -f "$HOME/.local/bin/kind-binary" ]; then
        print_warning "kind already installed"
        return
    fi

    mkdir -p "$HOME/.local/bin"

    if [ "$OS_TYPE" = "Darwin" ]; then
        curl -Lo "$HOME/.local/bin/kind" https://kind.sigs.k8s.io/dl/v0.26.0/kind-darwin-amd64
        chmod +x "$HOME/.local/bin/kind"
    else
        # For Linux, check if we need the wrapper (flatpak environment)
        if [ -n "$FLATPAK_ID" ]; then
            print_warning "Detected flatpak environment - installing with wrapper"
            curl -Lo "$HOME/.local/bin/kind-binary" https://kind.sigs.k8s.io/dl/v0.26.0/kind-linux-amd64
            chmod +x "$HOME/.local/bin/kind-binary"

            # Create wrapper
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
    fi

    print_success "kind installed"
}

check_docker() {
    print_header "Checking Docker"

    if ! command -v docker &> /dev/null; then
        print_warning "Docker not found. kind requires Docker to work."
        print_warning "Install Docker: https://docs.docker.com/engine/install/"
        return 1
    fi

    if ! docker ps &> /dev/null; then
        print_warning "Docker is installed but not accessible."
        print_warning "You may need to:"
        print_warning "  1. Start Docker daemon: sudo systemctl start docker"
        print_warning "  2. Add your user to docker group: sudo usermod -aG docker \$USER"
        print_warning "  3. Log out and back in"
        return 1
    fi

    print_success "Docker is available"
    return 0
}

# ============================================================================
# Main Installation
# ============================================================================

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                   DOTFILES INSTALLATION                       ║
║                                                               ║
║  Enhanced Bash + Starship + Kubernetes Tools                  ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo "Detected OS: $OS_TYPE"
    echo "Dotfiles directory: $DOTFILES_DIR"
    echo
}

main() {
    show_banner

    local install_mode="${1:-interactive}"

    case "$install_mode" in
        --all)
            print_header "Installing everything..."
            install_dotfiles
            install_starship
            install_kubectl
            install_kubectx_kubens
            install_k9s
            install_kind
            check_docker
            ;;
        --minimal)
            print_header "Installing dotfiles only..."
            install_dotfiles
            ;;
        *)
            # Interactive mode
            if ask_yes_no "Install dotfiles (.bashrc, starship, etc.)?" "y"; then
                install_dotfiles
            fi

            if ask_yes_no "Install Starship prompt?" "y"; then
                install_starship
            fi

            if ask_yes_no "Install Kubernetes tools (kubectl, kubectx, kubens, k9s, kind)?" "y"; then
                install_kubectl
                install_kubectx_kubens
                install_k9s
                install_kind
                check_docker
            fi
            ;;
    esac

    print_header "Installation Complete!"
    echo
    print_success "To apply changes, run: source ~/.bashrc"
    echo
    echo "Next steps:"
    echo "  1. Review the documentation: cat ~/docs/setup/README.md"
    echo "  2. Check the quick reference: cat ~/docs/setup/QUICK_REFERENCE.md"
    echo "  3. If using kind, ensure Docker is running and accessible"
    echo "  4. Start a new terminal to see the Starship prompt"
    echo
    echo -e "${GREEN}Enjoy your enhanced shell!${NC}"
}

# Run main installation
main "$@"
