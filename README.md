# DOTFILES

My development environment.

```
make all              # compile default programs
```


----
## GOALS

- store my configs
- set up a dev environment *without* root permissions
- compile versions that are newer than APT


----
## USAGE


for example:
```
make help             # show usage
make all              # compile default programs
make neovim           # compile editor
make alacritty        # compile terminal
make tmux             # compile terminal multiplexer
```

options
```
HOST_ALIAS=(<str>):   # user's nickname for their computer
NO_SYMLINKS=ON        # copy config directly instead of linking to files here
                      # useful if you delete this repo after install
INSTALL_RC=(ON|OFF):  # install config file for a target if ON, uninstall if OFF
```


----
## REQUIREMENTS

dependencies are specific to the target, but the basics are:
```
bash gcc gpg make git git-lfs curl wget perl
```

and one can check a recommended list:
```
make check_packages   # check for generic dependencies
```

and install these from your package manager to save time:
```
cmake gettext clang llvm
```


----
## TROUBLESHOOTING

Tested on Ubuntu, YMMV

- I got an error that said I'm missing packages!
    + please install the listed packages to the host
- this is taking forever!
    + speedup the builds by installing dependencies to your host if possible
- my terminal is acting weird! help!
    + call `set +o vi`, is it back to normal?
    + edit your `~/.inputrc` to change the vi/emacs mode
- the target installed but I can't run it!
    + check your `PATH`! PREFIX defaults to `$HOME/.local`
