# Install

```sh
sudo apt install vim curl git zsh stow
```

```sh
cd $HOME &&
git@github.com:jianzuguan/dotfiles.git &&
stow --adopt .
```

## oh-my-zsh

```sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Move to `$HOME/.local/share/oh-my-zsh`

## restart zsh

Make sure new `.zshrc` file take effect.

```sh
zsh
```

## power level 10k

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/themes/powerlevel10k
```

## zsh plugin

```sh
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open
```

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.local/share/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## fnm

```sh
curl -fsSL https://fnm.vercel.app/install | bash
```
