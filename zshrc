# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Current directory (handy variable)
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# Fix encoding bug
export LANG=en_US.UTF-8

# Set name of the theme to load. Optionally, if you set this to "random"
ZSH_THEME="robbyrussell"
plugins=(
  git
  vi-mode
  fzf
  colored-man-pages
  fancy-ctrl-z # ctrl + z foregrounds process again
)

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"

source $ZSH/oh-my-zsh.sh

alias ghostscript="/bin/gs"
alias gs="git status"
alias gh="git checkout"
alias ghub="command gh"
alias gb="git checkout -b"
alias gd="git branch --delete"
alias gpf="git push -u origin HEAD"
alias gpoops="git add . && git oops && git push -f"
alias gl='git pull'
alias grr='git-pull-all'
gcap() { git add . && git commit -m "$*" && git push }



# FZF
alias f='fzf'
# Default command for finding files (using fd)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Default options applied to all fzf invocations
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --preview "bat --style=numbers --color=always --line-range :500 {}"
  --preview-window=right:50%:hidden
  --bind "ctrl-/:toggle-preview"
  --bind "ctrl-y:execute-silent(echo {} | xclip -selection clipboard)"
'

# Ctrl+T configuration (file finder)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --line-range :50 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Alt+C configuration (directory finder)
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview 'tree -C {} | head -50'
"

# Ctrl+R configuration (history search)
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
  --color header:italic
  --header 'You are pindotitson'
"

# for fzf history
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

fzf-smart-cd() {
  local dir
  dir=$(
    {
      z -l 2>/dev/null | sed 's/^[0-9,.]* *//'
      fd --type d --hidden --exclude .git
    } | awk '!seen[$0]++' |
      fzf --height 40% --reverse
  )

  [[ -n "$dir" ]] && cd "$dir"
  zle reset-prompt
}
zle -N fzf-smart-cd
bindkey '^E' fzf-smart-cd

# Ctrl+A: paste a directory path onto the command line (dirs-only equivalent of Ctrl+T)
fzf-dir-paste() {
  local selected
  selected=$(
    fd --type d --hidden --follow --exclude .git |
      fzf --height 40% --reverse --preview 'tree -C {} | head -50'
  )
  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER}${(q)selected} "
  fi
  zle reset-prompt
}
zle -N fzf-dir-paste
bindkey '^A' fzf-dir-paste

fkill() {
  local pids
  pids=$(
    ps -eo pid=,comm=,args= --sort=-%cpu |
    awk -v OFS='\t' '{print $1, $2}' |
    fzf -m \
      --delimiter=$'\t' \
      --with-nth=1,2,3 \
      --preview 'echo PID: {3}' |
    cut -f3
  )

  [[ -n "$pids" ]] && echo "$pids" | xargs kill -${1:-9}
}


alias fssh='ssh $(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | fzf)'

# Jump to frequently used directories (requires z or autojump)
fz() {
  local dir
  dir=$(z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*}" | sed 's/^[0-9,.]* *//')
  cd "$dir"
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# change default text editor to nvim
export VISUAL=nvim
export EDITOR=nvim
alias vim=nvim
alias vi=nvim

# open all files with this pattern in them
vrg() {
  if [ $# -eq 0 ]; then
    echo "Usage: vgr <pattern> [rg-options...]"
    return 1
  fi
  rg -l "$@" | xargs -r nvim
}


# Set GOPATH and PATH for golang
# GOPATH sets the workspace where go code is in
# In this case we keep _all_ the go code in $HOME/go
export GOPATH="$HOME/go"
export GO111MODULE='on' # dunno what it does, but related to nvim-go
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:$HOME/bin"

export PATH="$PATH:$HOME/.local/bin"

# Some magic to make gpg2 work
export GPG_TTY=$(tty)

# Virtualenvwrapper (python) stuff
export WORKON_HOME=$HOME/.virtualenvs
export PATH="$PATH:$HOME/.local/bin"

# Rust binaries installed with cargo install <pkt>
export PATH="$PATH:$HOME/.cargo/bin"

# for lazy-commit and other scripts
export PATH="$PATH:$HOME/dotfiles/scripts"
# for dwmblocks
export PATH="$PATH:$HOME/dotfiles/scripts/blocks"

export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"

# Wasmer
export WASMER_DIR="/home/gmelodie/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
export PATH="$PATH:$HOME/.wasmtime/bin"

# digs alias (dig simple)
alias digs='dig +noall +answer +authority'
export WINEARCH=win32
export WINEPREFIX=/home/gmelodie/wine32

# cargo run | less -R (make this work with colors)
export CARGO_TERM_COLOR=always

# nim stuff
export PATH=/home/gmelodie/.nimble/bin:$PATH

# syntax highligthing for man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# rebuild suckless
alias suckr=rebuild-suckless

[ -z "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . $HOME/.nix-profile/etc/profile.d/nix.sh

alias lsrecent='ls -t | head -n 10'
alias o='xdg-open'
alias ai-docker="$HOME/repos/ai-docker/ai.sh"

# `ai` wraps ai-docker and also spawns a separate terminal opened at
# the first path argument — or its worktree, if -b is given. Focus is
# returned to this (claude) terminal after the new one is launched.
ai() {
    local first_path="" first_branch="" arg
    local folder_count=0 expect_branch=false expect_value=false past_separator=false
    for arg in "$@"; do
        if $past_separator; then continue; fi
        if [ "$arg" = "--" ]; then past_separator=true; continue; fi
        if $expect_branch; then
            [ $folder_count -eq 1 ] && first_branch="$arg"
            expect_branch=false
            continue
        fi
        if $expect_value; then expect_value=false; continue; fi
        case "$arg" in
            -b) expect_branch=true ;;
            -i|-c) expect_value=true ;;
            --codex|--rebuild|-h|--help) ;;
            *)
                folder_count=$((folder_count + 1))
                [ -z "$first_path" ] && first_path="$arg"
                ;;
        esac
    done

    local term_dir=""
    if [ -n "$first_path" ] && [ -d "$first_path" ]; then
        if [ -n "$first_branch" ]; then
            # Mirrors ai-docker's worktree path: <dirname>/<basename>--<branch with / → ->
            local abs branch_safe
            abs="$(cd "$first_path" && pwd)"
            branch_safe="${first_branch//\//-}"
            term_dir="$(dirname "$abs")/$(basename "$abs")--${branch_safe}"
        else
            term_dir="$first_path"
        fi
    fi

    if [ -n "$term_dir" ]; then
        # Remember the terminal we're launched from so focus returns to it
        # (the claude terminal) instead of staying on the spawned alacritty.
        local cur_win
        cur_win="$(xdotool getactivewindow 2>/dev/null)"
        (
            for _ in {1..150}; do
                [ -d "$term_dir" ] && break
                sleep 0.2
            done
            [ -d "$term_dir" ] || exit
            alacritty --working-directory "$term_dir" </dev/null >/dev/null 2>&1 &
            # Hand focus back to the claude terminal. dwm ignores
            # _NET_ACTIVE_WINDOW (windowactivate just marks the window urgent)
            # and its focusin handler overrides XSetInputFocus (windowfocus),
            # so the only reliable trigger is an EnterNotify: warp the pointer
            # over the claude window and dwm's enternotify focuses it.
            if [ -n "$cur_win" ]; then
                for _ in {1..50}; do
                    sleep 0.1
                    [ "$(xdotool getactivewindow 2>/dev/null)" != "$cur_win" ] && break
                done
                sleep 0.1
                xdotool mousemove --window "$cur_win" 20 20 2>/dev/null
            fi
        ) &!
    fi

    "$HOME/repos/ai-docker/ai.sh" "$@"
}
