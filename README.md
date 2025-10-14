# DOTFILES

My personal development environment.

I work on machines with missing or out of date packages, but I don't have sudo.

I found it was easier to just compile everything from scratch.

```bash
make help                     # show programs to compile
make all                      # install default programs & configs
make neovim tmux rust bash    # the essentials
```


----

## REQUIREMENTS

Dependencies are specific to the target, but:
```
bash make gcc gpg git git-lfs wget perl    # basic requirements
cmake clang llvm                           # these take a while so prefer your package manager
```


----

## USAGE

This compiles _a lot_ from scratch and could interact with other software in fun ways.

So if you're not working with me I don't recommend using it.

However, here are some tips:

You can use the defaults:
```
make all            # neovim, rust, python, tmux, etc.
```

Rules are provided for each program, and it's dependencies are listed in it's pre-reqs.
```
make neovim         # neovim, and also installs lua, rust, etc.
```

Compiling a program from a sub folder won't compile it's dependencies.
```
cd neovim
make all install    # neovim, but not lua and etc
```

Everything is installed to `$HOME/.local`, so you _must_ update your paths accordingly.
```
make bashrc         # updates PATH, LD_LIBRARY_PATH, etc.
```


----

## DESIGN


Design
- programs are divided into sub folders
- Makefile rules are written to compile everything
- the top level Makefile delegates to the sub folders
- the top level Makefile lists program dependencies as pre-reqs
- git hashes are used to see if the programs needs recompiling
- Ubuntu is the main OS, but I'm trying Red Hat slowly
- programs are added as I need them, it's not meant to automate everything for you

Goals
- does *not* use sudo
- sets up a new machine automatically
- compiles a good editor & supporting tools
- compiles a good terminal & terminal multiplexer
- displays git branch/hash in the PS1
- sets up vi motions for terminal & tmux
- sets up copy and paste over ssh


----


## ACKNOWLEDGEMENTS

Many thanks to Gerard Beekman for "Linux From Scratch", TJ DeVries for his neovim tutorials, and others.
