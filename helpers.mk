#!/usr/bin/make -f

# sundry Make functions


# print in green w/ INFO\t prefix
define log_info
	@echo -e "\e[32mINFO\t$1\e[39m"
endef


# print in yellow w/ WARN\t prefix
define log_warn
	@echo -e "\e[33mWARN\t$1\e[39m"
endef


# print in red w/ ERROR\t prefix
define log_error
	@echo -e "\e[91mERROR\t$1\e[39m"
endef


# safe git clone, clone repo 1 to dir 2
#	clone if dir DNE
#	clone if dir exists and is not a repo
#	1    git url
#	2    directory
define git_clone
	@echo "\e[32mINFO\tupdating $(1) -> $(2)\e[39m"
	if [ ! -d $(2) ]; then git clone $(1) $(2); fi;
	(git -C $(2) status 2>/dev/null) || git clone $(1) $(2) || true
endef


# safe git fetch/merge
#	fetch repo and reset to the target branch, discarding changes
#	1    directory
#	2    branch (master)
define git_reset
	@echo "\e[32mINFO\tupdating $(1) to $(if $(2),$(2),master)\e[39m"
	git -C $(1) fetch \
		&& git -C $(1) checkout $(if $(2),$(2),master) \
		&& git -C $(1) reset --hard origin/$(if $(2),$(2),master)
endef


# safe git clone, fetch, merge
#	clone 1 to dir 2, fetch, reset to 3
#	1    git url
#	2    directory
#	3    branch (master)
define update_repo
	$(call git_clone,$(1),$(2))
	$(call git_reset,$(2),$(3))
endef


#	Fetch and reset to origin/master
#	1    directory
define git_master
	@git -C $(1) fetch && git -C $(1) checkout master && git -C $(1) reset --hard origin/master
endef


# update a file at $2 with contents of $1
#	Copy if source is newer or the files differ, so repeated backup calls don't create duplicates
#	1    source
#	2    destination
define update_file
	@if [ $(1) -nt $(2) ]; then cp $(1) $(2); else cmp --silent $(1) $(2) || cp $(1) $(2); fi
endef


# uncomment a line in a file given a pattern if flag is ON, comment out else
#	1   filepath
#	2   pattern
#	3   flag (ON|OFF)
define comment_line
	@if [ "$3" == "ON" ]; then sed -i '/$(2)/s/^#*\s*//g' $(1); else sed -i '/$(2)/s/^#*/#/g' $(1); fi
endef

# append a 'source $3' call to a file $1
#      Appends the line if it does *not* exist
#      Uses the magic keyword as a comment (# delimited) to test if the call exists
#      1    filepath to append to
#      2    magic keyword
#      3    filepath to source
define source_file
	grep -q $(2) $(1) || echo "[ -r $(3) ] && source $(3)  # $(2)" >> $(1)
endef


# check if any deb packages are not installed using dpkg
#	print error if any aren ot installed, wait 3 sec
#	1	list of deb packages
define check_pkgs
	@for pkg in $(1); do \
		dpkg -s $$pkg 2>/dev/null | grep -q "install ok installed" || (echo -e "\033[;91mERROR  missing package:  $$pkg\033[0m"; sleep 3;) \
	done
endef
