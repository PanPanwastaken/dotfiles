export PATH="$HOME/.local/bin:$PATH"
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:$PKG_CONFIG_PATH
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

PINK='#ff6eb4'
PINK_SOFT='#ffb3d9'
BLUE='#7fdbff'
BLUE_SOFT='#9fefff'
DARK_PINK='#cc5890'
WHITE='#ffffff'

ZSH_THEME="powerlevel10k/powerlevel10k"

typeset -g POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$PINK
typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=$PINK
typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$BLUE_SOFT
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$BLUE_SOFT

typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=$PINK
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_FOREGROUND=$PINK
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_FOREGROUND=$DARK_PINK

typeset -g POWERLEVEL9K_VCS_FOREGROUND=$BLUE

source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[command]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=$PINK,bold"
ZSH_HIGHLIGHT_STYLES[function]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[alias]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=$BLUE,bold"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=$PINK"

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=$BLUE_SOFT"
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=$BLUE_SOFT"
ZSH_HIGHLIGHT_STYLES[arg0]="fg=$PINK"

ZSH_HIGHLIGHT_STYLES[parameter]="fg=$BLUE_SOFT"
ZSH_HIGHLIGHT_STYLES[assign]="fg=$WHITE"
ZSH_HIGHLIGHT_STYLES[named-fd]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[numeric-fd]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]="fg=$BLUE"

ZSH_HIGHLIGHT_STYLES[single-quoted-string]="fg=$PINK_SOFT"
ZSH_HIGHLIGHT_STYLES[double-quoted-string]="fg=$PINK_SOFT"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=$BLUE_SOFT"
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]="fg=$BLUE_SOFT"

ZSH_HIGHLIGHT_STYLES[path]="fg=$WHITE,underline"
ZSH_HIGHLIGHT_STYLES[path_pathseparator]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=$WHITE"
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=$BLUE"

ZSH_HIGHLIGHT_STYLES[redirection]="fg=$PINK,bold"
ZSH_HIGHLIGHT_STYLES[commandseparator]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[command-substitution]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[process-substitution]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]="fg=$PINK"

ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=$PINK_SOFT,bold"
ZSH_HIGHLIGHT_STYLES[comment]="fg=$DARK_PINK"
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$DARK_PINK,bold"
ZSH_HIGHLIGHT_STYLES[default]="fg=$WHITE"

ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=$BLUE"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=$PINK_SOFT"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=$BLUE_SOFT"

ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=$PINK"
ZSH_HIGHLIGHT_STYLES[global-alias]="fg=$PINK,bold"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza --group-directories-first --icons'
alias ll='eza -l --all --icons --group-directories-first'
alias sysstat='bash ~/.config/fastfetch/tmux_dashboard.sh'

export CUDA_HOME=/opt/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDACXX=$CUDA_HOME/bin/nvcc
