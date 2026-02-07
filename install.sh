#!/usr/bin/env bash
#
# install.sh - Dotfiles installer for a fresh Arch Linux system
#
# Bootstrap from a fresh system:
#   bash <(curl -fsSL https://raw.githubusercontent.com/PanPanwastaken/dotfiles/master/install.sh)
#
# Or if already cloned:
#   ./install.sh
#

set -e

REPO_URL="https://github.com/PanPanwastaken/dotfiles.git"
DOTFILES="$HOME/dotfiles"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[*]${NC} $1"; }
ok()   { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[-]${NC} $1"; }

confirm() {
    read -rp "$(echo -e "${YELLOW}[?]${NC} $1 [Y/n] ")" ans
    [[ -z "$ans" || "$ans" =~ ^[Yy] ]]
}

# ── Clone dotfiles ──────────────────────────────────────────────

clone_dotfiles() {
    if [[ -d "$DOTFILES/.git" ]]; then
        ok "Dotfiles already cloned at $DOTFILES"
        if confirm "Pull latest changes?"; then
            git -C "$DOTFILES" pull --rebase
            ok "Dotfiles updated"
        fi
    else
        if [[ -d "$DOTFILES" ]]; then
            warn "$DOTFILES exists but is not a git repo"
            if confirm "Back it up and clone fresh?"; then
                mv "$DOTFILES" "${DOTFILES}.bak.$(date +%s)"
            else
                err "Aborting"; exit 1
            fi
        fi

        log "Cloning dotfiles..."
        if ! command -v git &>/dev/null; then
            log "Installing git..."
            sudo pacman -S --needed --noconfirm git
        fi
        git clone "$REPO_URL" "$DOTFILES"
        ok "Dotfiles cloned to $DOTFILES"
    fi
}

# ── Pacman packages ──────────────────────────────────────────────

PACMAN_PKGS=(
    # Hyprland & session
    hyprland hypridle hyprlock xdg-desktop-portal-hyprland

    # Terminal & shell
    kitty zsh alacritty tmux

    # Launchers
    rofi

    # Status bar & notifications
    waybar mako libnotify

    # File management
    thunar yazi

    # Browser
    qutebrowser

    # Editors
    micro neovim

    # System monitors
    btop nvtop fastfetch

    # Screenshot & recording
    grim slurp wf-recorder wtype

    # Clipboard
    wl-clipboard cliphist

    # Audio & media
    pipewire pipewire-pulse wireplumber playerctl cava brightnessctl mpv yt-dlp

    # Networking
    networkmanager bluez bluez-utils blueman

    # Dev tools
    git github-cli jq socat

    # Wallpaper
    swww

    # Image processing
    imagemagick

    # Fonts
    ttf-jetbrains-mono-nerd otf-font-awesome noto-fonts noto-fonts-emoji

    # GTK/Qt theming
    qt6ct kvantum

    # Task management
    task

    # Icons
    papirus-icon-theme breeze-icons

    # Power management
    upower
)

# ── AUR packages ─────────────────────────────────────────────────

AUR_PKGS=(
    yay
    satty
    hyprlauncher
    phinger-cursors
    catppuccin-gtk-theme-mocha
    protonvpn-app
    swww
)

# ── Install pacman packages ──────────────────────────────────────

install_pacman() {
    log "Installing pacman packages..."
    local to_install=()
    for pkg in "${PACMAN_PKGS[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
        ok "Pacman packages installed"
    else
        ok "All pacman packages already installed"
    fi
}

# ── Install AUR helper & packages ────────────────────────────────

install_aur() {
    if ! command -v yay &>/dev/null; then
        log "Installing yay (AUR helper)..."
        local tmpdir
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
        (cd "$tmpdir/yay" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        ok "yay installed"
    fi

    log "Installing AUR packages..."
    local to_install=()
    for pkg in "${AUR_PKGS[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null 2>&1; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        yay -S --needed --noconfirm "${to_install[@]}"
        ok "AUR packages installed"
    else
        ok "All AUR packages already installed"
    fi
}

# ── Setup zsh + oh-my-zsh + powerlevel10k ────────────────────────

setup_zsh() {
    log "Setting up zsh..."

    # Set zsh as default shell
    if [[ "$SHELL" != */zsh ]]; then
        chsh -s "$(which zsh)"
        ok "Default shell set to zsh"
    fi

    # Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        ok "Oh My Zsh installed"
    else
        ok "Oh My Zsh already installed"
    fi

    # Powerlevel10k
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        log "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        ok "Powerlevel10k installed"
    else
        ok "Powerlevel10k already installed"
    fi

    # zsh-syntax-highlighting
    local syn_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    if [[ ! -d "$syn_dir" ]]; then
        log "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$syn_dir"
        ok "zsh-syntax-highlighting installed"
    else
        ok "zsh-syntax-highlighting already installed"
    fi

    # zsh-autosuggestions
    local auto_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    if [[ ! -d "$auto_dir" ]]; then
        log "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$auto_dir"
        ok "zsh-autosuggestions installed"
    else
        ok "zsh-autosuggestions already installed"
    fi
}

# ── Symlink dotfiles ─────────────────────────────────────────────

link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        warn "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -sf "$src" "$dst"
}

link_config_dir() {
    local src_base="$1/.config"
    [[ -d "$src_base" ]] || return

    while IFS= read -r -d '' file; do
        local rel="${file#$src_base/}"
        link "$file" "$HOME/.config/$rel"
    done < <(find "$src_base" -type f -print0)
}

symlink_dotfiles() {
    log "Symlinking dotfiles..."

    # .config directories - link each app folder
    for module in browser editors file-manager gtk-qt-themes hyprland launchers media notifications panscripts system-monitors terminal waybar; do
        local src="$DOTFILES/$module/.config"
        [[ -d "$src" ]] || continue

        for app_dir in "$src"/*/; do
            [[ -d "$app_dir" ]] || continue
            local app_name
            app_name=$(basename "$app_dir")
            link "$app_dir" "$HOME/.config/$app_name"
        done

        # Handle loose files in .config/ (not in subdirs)
        for file in "$src"/*; do
            [[ -f "$file" ]] || continue
            link "$file" "$HOME/.config/$(basename "$file")"
        done
    done

    # Home directory files
    [[ -f "$DOTFILES/git/.gitconfig" ]]       && link "$DOTFILES/git/.gitconfig"       "$HOME/.gitconfig"
    [[ -f "$DOTFILES/tasks/.taskrc" ]]         && link "$DOTFILES/tasks/.taskrc"         "$HOME/.taskrc"
    [[ -f "$DOTFILES/terminal/.zshrc" ]]       && link "$DOTFILES/terminal/.zshrc"       "$HOME/.zshrc"
    [[ -f "$DOTFILES/terminal/.bashrc" ]]      && link "$DOTFILES/terminal/.bashrc"      "$HOME/.bashrc"
    [[ -f "$DOTFILES/terminal/.bash_profile" ]]&& link "$DOTFILES/terminal/.bash_profile" "$HOME/.bash_profile"
    [[ -f "$DOTFILES/terminal/.p10k.zsh" ]]    && link "$DOTFILES/terminal/.p10k.zsh"    "$HOME/.p10k.zsh"
    [[ -f "$DOTFILES/gtk-qt-themes/.gtkrc-2.0" ]] && link "$DOTFILES/gtk-qt-themes/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

    # Themes directory
    link "$DOTFILES/themes/themes" "$HOME/themes"

    ok "Dotfiles symlinked"
}

# ── Make scripts executable ──────────────────────────────────────

set_permissions() {
    log "Setting script permissions..."
    find "$DOTFILES" -name "*.sh" -exec chmod +x {} +
    ok "Scripts made executable"
}

# ── Enable services ──────────────────────────────────────────────

enable_services() {
    log "Enabling systemd services..."

    sudo systemctl enable --now NetworkManager 2>/dev/null || true
    sudo systemctl enable --now bluetooth 2>/dev/null || true
    systemctl --user enable --now pipewire 2>/dev/null || true
    systemctl --user enable --now pipewire-pulse 2>/dev/null || true
    systemctl --user enable --now wireplumber 2>/dev/null || true

    ok "Services enabled"
}

# ── Apply current theme ──────────────────────────────────────────

apply_theme() {
    local current_theme
    if [[ -f "$DOTFILES/themes/themes/.current" ]]; then
        current_theme=$(cat "$DOTFILES/themes/themes/.current")
    else
        current_theme="teto"
    fi

    if confirm "Apply theme '$current_theme'?"; then
        log "Applying theme: $current_theme"
        bash "$DOTFILES/themes/themes/scripts/theme-apply.sh" "$current_theme" || warn "Theme apply had issues (may need running desktop)"
    fi
}

# ── Main ─────────────────────────────────────────────────────────

main() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║      panpan's dotfiles installer     ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
    echo ""

    clone_dotfiles

    if confirm "Install pacman packages?"; then
        install_pacman
    fi

    if confirm "Install AUR packages?"; then
        install_aur
    fi

    if confirm "Setup zsh + oh-my-zsh + powerlevel10k?"; then
        setup_zsh
    fi

    if confirm "Symlink dotfiles?"; then
        symlink_dotfiles
    fi

    set_permissions

    if confirm "Enable system services (NetworkManager, Bluetooth, PipeWire)?"; then
        enable_services
    fi

    apply_theme

    echo ""
    ok "All done! Log out and back in (or reboot) to start Hyprland."
    echo ""
}

main "$@"
