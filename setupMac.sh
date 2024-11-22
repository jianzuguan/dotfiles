#! /bin/bash

# on-my-zsh config
export ZSH=$HOME/.local/share/oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install coreutils
brew install fnm
brew install git
brew install ollama
brew install stats
brew install stow
brew install tfenv
brew install zoxide

brew install --cask alt-tab
brew install --cask arc
brew install --cask bitwarden
brew install --cask grammarly-desktop
brew install --cask logitech-options
brew install --cask loop # window manager
brew install --cask obsidian

# install on-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# power level 10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  $ZSH_CUSTOM/themes/powerlevel10k

# zsh plugin
git clone https://github.com/paulirish/git-open.git \
  $ZSH_CUSTOM/plugins/git-open

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# my dot files
mv $HOME/.zshrc $HOME/.zshrc.bak

git clone https://github.com/jianzuguan/dotfiles.git \
  $HOME/dotfiles

cd $HOME/dotfiles
git checkout modules

echo "---running stow---"
stow git
stow npm
stow tokens
stow vim
stow zsh

echo "--- update api tokens ---"
cp $HOME/.config/tokens/env.example.zsh $HOME/.config/tokens/env.zsh

source $HOME/.zshrc
