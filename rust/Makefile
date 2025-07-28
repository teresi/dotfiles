#!/usr/bin/make -f

# install and update rust
#
# installs to $HOME
# NB this *ignores* an existing system install (e.g. /usr/)
# so this requires you to manage your PATH!


include ../helpers.mk
SHELL := /bin/bash


CARGO_HOME := $(HOME)/.cargo
CARGO_ENV := $(CARGO_HOME)/env
_install := $(CARGO_HOME)/bin/rustup


.PHONY: all
all: rustup.sh


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	rm rustup.sh


.PHONY: uninstall
uninstall:
	$(call log_info,uninstalling rust...)
	source $(CARGO_ENV) && rustup self uninstall


.PHONY: download
download: $(_src)


.PHONY: update
update: $(_install)
	$(call log_info,updating rust...)
	source $(CARGO_ENV) && rustup update stable


rustup.sh:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o $@


$(_install): rustup.sh
	$(call log_info,installing $@...)
	# RUSTUP_INIT_SKIP_PATH_CHECK=yes allows installation alongside existing /usr/bin
	#	this check is done b/c if you don't pay attention to your PATH,
	#	you could accidentally run the wrong rust (/usr/bin vs HOME/.cargo etc.)
	@which /usr/bin/rustc && \
		(echo -e "\e[33mWARN\trustc detected at /usr/bin, installing to HOME, manage your PATH accordingly\e[39m"; sleep 3)
	cat $< | RUSTUP_INIT_SKIP_PATH_CHECK=yes sh -s -- -y
