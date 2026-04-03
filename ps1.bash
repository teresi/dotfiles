################################################################################
# PROMPT  ######################################################################
#     example prompt:
#     [<n jobs>][<HH:MM> <alias>][<git branch>]:<$PWD>
#     [<vi mode>]:▸$

# get current branch name, or empty str if none
git_br() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# get git hash, or empty str if none
git_hash() {
    git rev-parse HEAD 2>/dev/null | head -c 4
}

PS1_BACKUP=$PS1
if [[ -f ~/.config/host_alias ]]; then
    # MAGIC our convention, store the alias in a file
    HOST_ALIAS=$(cat ~/.config/host_alias)
else
    HOST_ALIAS="$HOSTNAME"
fi
export HOST_ALIAS                                                                             # nickname for this computer
PS1='\[\033[01;37m\]`[ \j -gt 0 ] && echo [\j]`\[\033[00m\]\'                                 # no. background tasks if any
PS1+='[\033[01;32m\][\A $HOST_ALIAS]\[\033[00m\]'                                             # clock and alias
PS1+='\[\033[01;90m\]`[ -n "$(git_br)" ] && echo [$(git_br)]\-\>\($(git_hash)\)`\[\033[00m\]' # git branch if any
PS1+=':\[\033[01;34m\]\w\[\033[00m\]'                                                         # current path
PS1+='\n\$ '                                                                                  # vi mode (if using) and '$' symbol
