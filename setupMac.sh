#! /bin/bash

# on-my-zsh config
export ZSH=$HOME/.config/oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install coreutils
brew install fnm
brew install fzf
brew install gh
brew install git
brew install herdr
brew install jq
brew install lsd
brew install oven-sh/bun/bun
brew install stats
brew install stow
brew install tfenv
brew install zoxide

brew install kubelogin
brew install kubernetes-cli

brew install --cask alt-tab
brew install --cask bitwarden
brew install --cask brave-browser
brew install --cask claude
brew install --cask claude-code
brew install --cask google-chrome
brew install --cask mpv
brew install --cask obs
brew install --cask obsidian
brew install --cask openlogi
brew install --cask slack
brew install --cask visual-studio-code

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
git checkout main

echo "---running stow---"
stow lsd
stow git
stow herdr
stow npm
stow secrets
stow vim
stow zsh

echo "--- update api secrets ---"
cp $HOME/.config/secrets/secrets.example.zsh $HOME/.config/secrets/secrets.zsh

source $HOME/.zshrc
