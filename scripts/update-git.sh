#!/bin/bash

# Enters a directory and tries to pull
# Examples:

# update-git this-repo
# update-git $HOME/my-special-repo

dir=$(readlink -f $1) # expand path
git --git-dir=$dir/.git stash save
git --git-dir=$dir/.git pull --rebase
git --git-dir=$dir/.git stash pop

