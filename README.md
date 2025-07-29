# DOTFILES

My development environment.

```bash
make all              # install default programs & configs
```


----
## USAGE


for example:
```bash
make help             # usage
make all              # compile defaults
make clean            # clean all
make download         # clone sources
make neovim           # compile editor
make alacritty        # compile terminal
make tmux             # compile terminal multiplexer
```

options:
```bash
HOST_ALIAS=(<str>):   # user's nickname for their computer
NO_SYMLINKS=ON        # copy config directly instead of linking to files here
                      # useful if you delete this repo after install
INSTALL_RC=(ON|OFF):  # install config file for a target if ON, uninstall if OFF
CPYTHON=3.XX          # set python version for cpython
```


----
## REQUIREMENTS

dependencies are specific to the target, but the basics are:
```
bash make gcc gpg git git-lfs wget perl
```

install these from package manager to save time:
```
cmake clang llvm
```


----
## GOALS & MOTIVATION

I work on machines with missing or out of date packages, but I don't have sudo.

I found it was easier to just compile everything.

Notably:

- does *not* use sudo
- compiles a good editor & supporting tools
- compiles a good terminal & terminal multiplexer
- displays git branch/hash in the PS1
- sets up a new machine automatically
- sets up vi motions for terminal & tmux
- sets up copy and paste over ssh
