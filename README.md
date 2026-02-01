# DOTFILES

My personal development environment.

I work on machines with missing or out of date packages, but I don't have sudo.

I found it was easier to just compile everything from scratch.

```bash
make help                                     # show programs to compile
make all                                      # install default programs & configs
make neovim tmux rust bash                    # the essentials
```


----

## REQUIREMENTS

Dependencies are specific to the target, but:
```bash
bash make gcc g++ gpg git git-lfs curl perl wget
cmake clang llvm                              # prefer your package manager due to long compilation times
```


----

## USAGE

This compiles _a lot_ from scratch, and will interact with other software in ✨fun✨ ways.

So I don't recommend using it if you're not working with me.

However, one can:

Use the top level Makefile to compile one program (and it's dependencies):
```bash
make neovim                     # neovim, and also installs lua, rust, etc.
```

Subfolders house individual programs (but it won't auto compile dependencies):
```bash
cd neovim
make all install                # neovim, but not lua and etc.
```

Installs to `$HOME/.local`, so update your paths!
```bash
export PATH+=:$HOME/.local/bin  # for this session
make bashrc                     # for future sessions
```

Display your branch and hash in your PS1:
```
user@host:~/dotfiles$ make HOST_ALIAS=COMPY host_alias bashrc && source ~/.bashrc
[20:32 COMPY][master]->(5d0d):~/dotfiles
[ins]▸$
```



----

## DESIGN

- does *not* use sudo
- top level Makefile
    + has rules for various programs
    + lists a programs dependencies in the prerequisites
    + delegates to sub folders
- sub folders:
    + compiles one program
    + assumes you have the dependencies
- uses git, pulls master or main, recompiles if the commit changes
- downloads `tar` files for 'releases', use gpg to verify
- tested on Ubuntu, future support for RedHat


## FEATURES

- setup neovim, tmux, python, rust
- vi mode for the terminal, and a better PS1
- support SSH, copy/paste, autostart SSH agent, etc.
- installs to `$HOME/.local` by default


----


## ACKNOWLEDGEMENTS

Many thanks to Gerard Beekman for "Linux From Scratch", TJ DeVries for his neovim tutorials, and others.
