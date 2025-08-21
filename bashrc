# sundry bashrc settings

_notify () {
	# info message, green text prepended w/ "INFO  "
	echo -e "\e[32mINFO\t$1 \e[39m"
}

_warn () {
	# warning message, yellow text prepended w/ "WARN  "
	echo -e "\e[33mWARN\t$1 \e[39m"
}


################################################################################
# PATH  ########################################################################

# MAGIC $HOME/.local/bin is a standard location for binaries
# NB prepend the location so we prefer our builds
if [ -w "$HOME"/.local/bin ]; then
	export PATH="$HOME"/.local/bin:$PATH
fi
if [ -w "$HOME"/.local/lib ]; then
	export LD_LIBRARY_PATH+=:"$HOME"/.local/lib
fi
if [ -w "$HOME"/.local/include ]; then
	export CFLAGS+=" -I$HOME/.local/include"
fi


################################################################################
# KEYBOARD  ####################################################################

# remap the CapsLock key to a Control key for X Window system
ctrl_no_caps ()
{
	if type setxkbmap >/dev/null 2>&1; then
		setxkbmap -layout us -option ctrl:nocaps 2>/dev/null
	fi
}

# turn off CapsLock if it's set
caps_off ()
{
	# ignoring err b/c we don't have an X display in an SSH session, so xset fails
	caps_lock_status=$(xset -q 2> /dev/null | sed -n 's/^.*Caps Lock:\s*\(\S*\).*$/\1/p')
	if [ "$caps_lock_status" == "on" ]; then
		xdotool key Caps_Lock
	fi
}

# if we're not in an SSH session, turn of caps lock and remap
if [ -z "$SSH_CLIENT" ] || [ -z "$SSH_TTY" ] || [ -z "$SSH_CONNECTION" ]; then
	# disown b/c we don't need it to print when it succeeds
	caps_off & disown
	ctrl_no_caps & disown
fi


################################################################################
# SSH    #######################################################################

# run the ssh agent if we're in an SSH session so we cache our keys
if [ -n "$SSH_TTY" ] && [ -z "$SSH_AGENT_PID" ] && [ -z "$SSH_AUTH_SOCK" ]; then
	_notify "SSH session is active but SSH AGENT is not running"
	_notify "starting ssh-agent..."
	# start the agent
	eval "$(ssh-agent -s)"
	if [ "$?" != 0 ]; then
		_warn "ssh-agent failed to start using 'ssh-agent -s'"
	else
		ssh-add -l &> /dev/null || (_notify "ssh started and keys are empty, adding your default key..."; ssh-add)
	fi
fi


################################################################################
# SHELL  #######################################################################

export TERM=screen-256color;          # fix vim colors inside tmux
export TZ='America/New_York';         # fix clock in tmux using the wrong TZ
export VISUAL=vim;                    # default editor
export EDITOR="$VISUAL";              # set default editor for legacy programs

export HISTSIZE='98304';              # no. lines stored in memory for a session
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

export PYTHON_BASIC_REPL=1            # re-enable vi mode for python3.13 REPL


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
	# MAGIC our convention, store the alias in a file
	HOST_ALIAS=`cat ~/.config/host_alias`;
else
	HOST_ALIAS="$HOSTNAME";
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
