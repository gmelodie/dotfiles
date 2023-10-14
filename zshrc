# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Current directory (handy variable)
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# Fix encoding bug
export LANG=en_US.UTF-8

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  vi-mode
  fzf
  colored-man-pages
  fancy-ctrl-z # ctrl + z foregrounds process again
  # magic-enter
  # zsh-z           # cd to most frequent dirs
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi


# Magic Enter configs
# MAGIC_ENTER_GIT_COMMAND='git status -u .' # -> default
# MAGIC_ENTER_GIT_COMMAND='ls' # -> default
# MAGIC_ENTER_OTHER_COMMAND='ls'


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias ghostscript="/bin/gs"
alias gs="git status"
alias gh="git checkout"
alias gb="git checkout -b"
alias gpf="git push -u origin HEAD"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# change default text editor to nvim
export NVIM_APPIMAGE="$HOME/.nvim/nvim.appimage"
export VISUAL="$NVIM_APPIMAGE"
export EDITOR="$NVIM_APPIMAGE"
alias vim="$NVIM_APPIMAGE"
alias v="$NVIM_APPIMAGE"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set GOPATH and PATH for golang
# GOPATH sets the workspace where go code is in
# In this case we keep _all_ the go code in $HOME/go
export GOPATH=$HOME/go
export GO111MODULE='on' # dunno what it does, but related to nvim-go
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$(go env GOPATH)/bin"

# Some magic to make gpg2 work
export GPG_TTY=$(tty)

# Virtualenvwrapper (python) stuff
export WORKON_HOME=$HOME/.virtualenvs
export PATH="$PATH:$HOME/.local/bin"

# Rust binaries installed with cargo install <pkt>
export PATH="$PATH:$HOME/.cargo/bin"

# workaround for stremio not closing bug
alias close_stremio="fclose stremio"

# force close any
# usage: fclose stremio
function fclose {
    for process in $(ps aux | grep $1 | cut -d " " -f 5); do
        kill -9 $process 2>/dev/null;
    done
}

# For my scripts
# export PATH=$PATH:$HOME/scripts
setopt +o nomatch # https://unix.stackexchange.com/a/310553/235577
for script in $(ls $HOME/scripts/*.sh 2>/dev/null); do
    source $script
done

alias say="spd-say"

# for lazy-commit and other scripts
export PATH="$PATH:$HOME/dotfiles/scripts"

alias godog="in your face why"

# Wasmer
export WASMER_DIR="/home/gmelodie/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
export PATH="$PATH:$HOME/.wasmtime/bin"

# digs alias (dig simple)
alias digs='dig +noall +answer +authority'
