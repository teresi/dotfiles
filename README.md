# DOTFILES

Install configs, compile utilities.

e.g.
- bash / vim / tmux
- alacritty
- gnome settings


----
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
NO_SYMLINKS=ON              # copy config directly instead of linking to files here
                            # useful if you delete this repo after install
```


----
## TODO
- add xsel
- add xclip
- add wmctrl
- add xdootool
- add ranger
- add curl|wget?
- refactor ninja, double check it pulls/rebuilds
- refactor old scripts, e.g. move from bash scripts to sub dir w/ Makefile
