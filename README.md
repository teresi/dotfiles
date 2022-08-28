# DOTFILES

User configuration.

Includes:
- bashrc / vimrc / tmux.conf
- vim plugins / tmux plugins
- alacritty
- fzf
- gnome settings


## USAGE

```
make all                    # default configuration
make alacritty              # compile / install alacritty terminal
make help                   # show usage
```

Options
```
INSTALL_RC=(ON|OFF):        # install config file for a target if ON, uninstall if OFF
HOST_ALIAS=(<str>):         # user's nickname for their computer
```


## DESIGN


Symlinks dotfiles from `~/` and `~/.config/` pointing to this repo,
  in order to simplify updates & backup procedures.

Nests dotfiles if possible to decouple configurations.

Installs to user space where ever possible,
  in order limit need for root privileges.


## CAVEAT

If this repo is deleted then most customizations will also be deleted,
  as the dotfiles are symlinked to the files in this repo.
