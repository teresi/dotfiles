# DOTFILES

User configuration.

Includes:
- vimrc / bashrc / tmux.conf
- vundle / vim plugins
- alacritty
- fzf
- gnome settings


## USAGE

```
make all                    # default configuration
make help                   # show usage
```

Options
```
INSTALL_RC=(ON|OFF):        # install config file for a target if ON, uninstall if OFF
```


## DESIGN

Installs to user space where ever possible to limit need for root privileges.
