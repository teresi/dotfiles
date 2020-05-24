#/bin/bash
# set/unset key mappings

unset=''

print_usage() {
  echo "keymaps - apply keyboard settings"
  echo ""
  echo "CAPS mapped to:    CTRL"
  echo ""
  echo "usage: keymaps.sh -h | -u | -s"
  echo ""
  echo "-h                 display usage"
  echo "-s                 set configuration"
  echo "-u                 unset options back to defaults"
}

while getopts 'ush' flag; do
  case "${flag}" in
    u) unset='true' ;;
    s) set='true' ;;
    h) print_usage
       exit 1;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ $unset ]
then
	# empty option means 'defaults'
	setxkbmap -option
	exit 0
fi

if [ $set ]
then
	setxkbmap -option "ctrl:nocaps"  # CAPS is now CTRL
	exit 0
fi

print_usage
