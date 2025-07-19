#!/usr/bin/make -f


# benchmark tool
# used for database benchmarks but here it's compiled w/o SQL


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/akopytov/sysbench.git
_src := sysbench
_branch := master
_bin := $(_src)/src/sysbench
_install := $(PREFIX)/bin/sysbench


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	make -C $(_src) uninstall


.PHONY: download
download: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ./autogen.sh
	@# requires make automake libtool pkg-config libaio-dev
	cd $(_src) \
		&& LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \
		./configure --prefix=$(HOME)/.local --without-mysql
	make -C $(_src) all -j


$(_install): $(_bin)
	make -C $(_src) install


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
