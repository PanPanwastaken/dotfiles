#!/usr/bin/env bash
# grid-launcher.sh - Fullscreen grid launcher with nerd font icons

declare -A ICONS=(
    # Browsers
    ["qutebrowser"]="󰖟" ["firefox"]="" ["chromium"]="" ["brave-browser"]="󰖟"
    ["google-chrome-stable"]="" ["vivaldi-stable"]="󰖟"
    # Terminals
    ["kitty"]="" ["alacritty"]="" ["foot"]="" ["wezterm"]=""
    # File Managers
    ["thunar"]="" ["nautilus"]="" ["pcmanfm"]="" ["nemo"]="" ["dolphin"]=""
    # Communication
    ["discord"]="󰙯" ["telegram-desktop"]="" ["slack"]="󰒱"
    ["signal-desktop"]="" ["element-desktop"]=""
    # Media
    ["spotify"]="" ["mpv"]="" ["vlc"]="󰕼" ["audacious"]=""
    ["cava"]="" ["easyeffects"]=""
    # Development
    ["code"]="󰨞" ["nvim"]="" ["neovide"]="" ["micro"]=""
    ["github-desktop"]="" ["codium"]="󰨞"
    # System
    ["btop"]="" ["htop"]="" ["nvtop"]=""
    ["pavucontrol"]="" ["pwvucontrol"]=""
    # Settings
    ["qt6ct"]="" ["qt5ct"]="" ["kvantum-manager"]="" ["nwg-look"]=""
    # Games
    ["steam"]="󰓓" ["lutris"]="󰊗" ["heroic"]="󰊗"
    # Network
    ["blueman-manager"]="󰂯" ["nm-connection-editor"]="󰤨"
    # Graphics
    ["gimp"]="" ["inkscape"]="" ["krita"]=""
    # VPN
    ["protonvpn-app"]="󰦝" ["protonvpn"]="󰦝"
    # Utilities
    ["obs"]="" ["satty"]="" ["flameshot"]=""
    ["org.gnome.Calculator"]="" ["gnome-calculator"]=""
    ["eog"]="" ["loupe"]="" ["evince"]="" ["zathura"]=""
    ["fastfetch"]="" ["neofetch"]=""
    # Office
    ["libreoffice"]="" ["thunderbird"]="󰇮"
)

declare -A CAT_ICONS=(
    ["WebBrowser"]="󰖟" ["TerminalEmulator"]="" ["FileManager"]=""
    ["TextEditor"]="" ["Audio"]="" ["AudioVideo"]="" ["Video"]=""
    ["Game"]="󰊗" ["Settings"]="" ["System"]="" ["Development"]=""
    ["Graphics"]="" ["Network"]="󰤨" ["Office"]="" ["Utility"]=""
    ["InstantMessaging"]="󰭹" ["Email"]="󰇮" ["Education"]=""
    ["Science"]="" ["Math"]="" ["Emulator"]="󰊗" ["Player"]=""
)

DEFAULT_ICON=""

get_icon() {
    local name="${1,,}"
    local cats="$2"

    [[ -n "${ICONS[$name]}" ]] && { echo "${ICONS[$name]}"; return; }

    IFS=';' read -ra arr <<< "$cats"
    for c in "${arr[@]}"; do
        [[ -n "${CAT_ICONS[$c]}" ]] && { echo "${CAT_ICONS[$c]}"; return; }
    done

    echo "$DEFAULT_ICON"
}

TMPDIR=$(mktemp -d)
trap "rm -rf '$TMPDIR'" EXIT
COMBINED="$TMPDIR/combined"

declare -A seen

for desktop in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
    [[ -f "$desktop" ]] || continue

    name="" exec_cmd="" cats="" nodisplay="" hidden=""
    while IFS='=' read -r key value; do
        case "$key" in
            Name) [[ -z "$name" ]] && name="$value" ;;
            Exec) [[ -z "$exec_cmd" ]] && exec_cmd="$value" ;;
            Categories) cats="$value" ;;
            NoDisplay) nodisplay="$value" ;;
            Hidden) hidden="$value" ;;
        esac
    done < <(grep -E '^(Name|Exec|Categories|NoDisplay|Hidden)=' "$desktop" 2>/dev/null)

    [[ "$nodisplay" == "true" || "$hidden" == "true" ]] && continue
    [[ -z "$name" || -z "$exec_cmd" ]] && continue
    [[ -n "${seen[$name]}" ]] && continue
    seen[$name]=1

    clean_exec=$(echo "$exec_cmd" | sed 's/ %[fFuUdDnNickvm]//g')
    exec_base=$(basename "${clean_exec%% *}")

    icon=$(get_icon "$exec_base" "$cats")
    printf '%s\t%s\n' "${icon}  ${name}" "$clean_exec" >> "$COMBINED"
done

sort -t$'\t' -k1 "$COMBINED" -o "$COMBINED"

selected_idx=$(cut -f1 "$COMBINED" | rofi -dmenu -i -p "" \
    -format 'i' \
    -theme ~/.config/rofi/launchers/type-2/grid-launcher.rasi \
    2>/dev/null)

[[ -z "$selected_idx" || "$selected_idx" == "-1" ]] && exit 0

exec_cmd=$(awk -F'\t' "NR==$((selected_idx + 1)) {print \$2}" "$COMBINED")
[[ -n "$exec_cmd" ]] && exec $exec_cmd &>/dev/null &
