#! /bin/sh

git pull

echo "---running stow---"
stow git
stow npm
stow tokens
stow vim
stow zsh
