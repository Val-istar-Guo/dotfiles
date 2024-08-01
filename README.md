# Val.istar.Guo’s dotfiles

# Prerequisites

- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [direnv](https://github.com/direnv/direnv/tree/master)
- [fnm](https://github.com/Schniz/fnm)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

```bash
git clone https://github.com/val-istar-guo/dotfiles.git && cd dotfiles && ./install.sh && source ~/.zshrc;
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
git pull
```

## Extends

| Path                   | Description             |
| :--------------------- | :---------------------- |
| ~/.dotfiles/.gitconfig | add personal git config |
| ~/.dotfiles/ssh/\*     | add personal ssh config |
