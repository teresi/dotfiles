# DOTFILES

Development environment.

```
make all              # compile & configure default programs
```

----
## USAGE


specific programs, e.g.
```
make help             # show usage
make neovim           # editor
make alacritty        # terminal
make tmux             # terminal multiplexer
```

dependencies are built on a per target basis
```
make check_packages   # check for generic dependencies
```

options
```
HOST_ALIAS=(<str>):   # user's nickname for their computer
NO_SYMLINKS=ON        # copy config directly instead of linking to files here
                      # useful if you delete this repo after install
INSTALL_RC=(ON|OFF):  # install config file for a target if ON, uninstall if OFF
```

----
## GOALS

- needed a way to setup a development environment without root permissions
- compiles dependencies from source (skips if available)
- primary focus is for the terminal


----
## TROUBLESHOOTING

This is tested on Ubuntu, YMMV

- this is taking forever!
    + speedup the builds by installing dependencies to your host if possible
    + recommend installing particular: `cmake`, `gettext`, `clang`, `llvm`
- my terminal is acting weird! help!
    + call `set +o vi`, is it back to normal?
    + edit your `~/.inputrc` to change the vi/emacs mode
- the target installed but I can't run it!
    + PREFIX defaults to `$HOME/.local`, this will need to be in your `PATH`
    + see `make bash`
- I got an error that said I'm missing packages!
    + please install the listed packages to the host
