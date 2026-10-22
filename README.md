
# Mac Install

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/jianzuguan/dotfiles/main/setupMac.sh)"
```

# WSL2 Install

```sh
sudo apt install vim curl git zsh stow
```

```sh
git clone git@github.com:jianzuguan/dotfiles.git $HOME/dotfiles &&
cd $HOME/dotfiles &&
stow git herdr lsd npm secrets vim zsh
```

Or run `setupDebian.sh`, which does all of the below.

## secrets

API tokens live in the git-ignored `secrets/.config/secrets/secrets.zsh`. Create it from the example and fill in the values.

```sh
cp ~/.config/secrets/secrets.example.zsh ~/.config/secrets/secrets.zsh
```

## oh-my-zsh

```sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Move to `$HOME/.config/oh-my-zsh`

## restart zsh

Make sure new `.zshrc` file take effect.

```sh
zsh
```

## power level 10k

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/themes/powerlevel10k
```

## zsh plugin

```sh
git clone https://github.com/paulirish/git-open.git $ZSH_CUSTOM/plugins/git-open
```

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## fnm

https://github.com/Schniz/fnm

```sh
curl -fsSL https://fnm.vercel.app/install | bash
```

## zoxide

https://github.com/ajeetdsouza/zoxide

```sh
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```


