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
