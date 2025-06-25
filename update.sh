#! /bin/sh

git pull

echo "---running stow---"
stow bin
stow git
stow npm
stow tokens
stow vim
stow zsh
