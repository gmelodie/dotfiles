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

source $ZSH/oh-my-zsh.sh

alias ghostscript="/bin/gs"
alias gs="git status"
alias gh="git checkout"
alias gb="git checkout -b"
alias gd="git branch --delete"
alias gpf="git push -u origin HEAD"
alias gpoops="git add . && git oops && git push -f"

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
alias f="fzf"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# change default text editor to nvim
export VISUAL=nvim
export EDITOR=nvim
alias vim=nvim
alias vi=nvim

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set GOPATH and PATH for golang
# GOPATH sets the workspace where go code is in
# In this case we keep _all_ the go code in $HOME/go
export GOPATH="$HOME/go"
export GO111MODULE='on' # dunno what it does, but related to nvim-go
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"

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
