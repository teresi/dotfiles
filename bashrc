# sundry bashrc settings


################################################################################
# PATH  ########################################################################
export PATH+=:"$HOME"/.local/bin     # user bins, e.g. alacritty, virtualenvwrapper, etc.
export PATH+=:/data/.local/bin       # user bins, e.g. alacritty, virtualenvwrapper, etc.


################################################################################
# KEYBOARD  ####################################################################

# Remap the CapsLock key to a Control key for X Window system
if type setxkbmap >/dev/null 2>&1; then
        setxkbmap -layout us -option ctrl:nocaps 2>/dev/null
fi


################################################################################
# SHELL  #######################################################################

export TERM=screen-256color;          # fix vim colors inside tmux
export TZ='America/New_York';         # fix clock in tmux using the wrong TZ
export VISUAL=vim;                    # default editor
export EDITOR="$VISUAL";              # set default editor for legacy programs

export HISTSIZE='65536';              # no. lines stored in memory for a session
export HISTFILESIZE='131072';         # no. lines stored in history file
export HISTTIMEFORMAT="[%F %T] ";     # add timestamps to history
HISTIGNORE='ls:bg:fg:history';
HISTIGNORE+=':git status:git diff:git branch -a';
export HISTIGNORE;                    # ignore specific commands
export PROMPT_COMMAND='history -a';   # record history immediately (not one session exit)

export LESS_TERMCAP_mb=$'\e[1;32m'    # colored manpages
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'


################################################################################
# PROMPT  ######################################################################
#     example prompt:
#     [<n jobs>][<HH:MM> <alias>][<git branch>]:<$PWD>
#     [<vi mode>]:▸$

# get current branch name, or empty str if none
git_br ()
{
	git rev-parse --abbrev-ref HEAD 2> /dev/null
}

# get git hash, or empty str if none
git_hash ()
{
	git rev-parse HEAD 2> /dev/null | head -c 4
}

PS1_BACKUP=$PS1
if [[ -f ~/.config/host_alias ]]; then
	HOST_ALIAS=`cat ~/.config/host_alias`;  # location of this computer's host alias
else
	HOST_ALIAS="COMPY";  # default alias
fi
export HOST_ALIAS                     # nickname for this computer
PS1='\[\033[01;37m\]`[ \j -gt 0 ] && echo [\j]`\[\033[00m\]\'  # no. background tasks if any
PS1+='[\033[01;32m\][\A $HOST_ALIAS]\[\033[00m\]'  # clock and alias
PS1+='\[\033[01;90m\]`[ -n "$(git_br)" ] && echo [$(git_br)]\-\>\($(git_hash)\)`\[\033[00m\]' # git branch if any
PS1+=':\[\033[01;34m\]\w\[\033[00m\]' # current path
PS1+='\n\$ '                          # vi mode (if using) and '$' symbol


################################################################################
# BUGFIXES #####################################################################

export CONDA_AUTO_ACTIVATE_BASE=false # prevent conda from automatically activating 'base' env

if [ ! -z "$TMOUT" ]; then            # prevent terminal from closing and deleting your work
	exec env TMOUT='' bash
fi
