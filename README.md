# Install

## oh-my-zsh

`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

Move to `$HOME/.local/share/oh-my-zsh`

## install yadm

`yadm clone git@github.com:jianzuguan/dotfiles.git`

## power level 10k

`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/themes/powerlevel10k`

## zsh plugin

`git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/plugins/zsh-autosuggestions`

`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting`
