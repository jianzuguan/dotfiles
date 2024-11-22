#! /bin/sh

git pull

echo "---running stow---"
stow git
stow vim
stow zsh
