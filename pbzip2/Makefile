#!/usr/bin/env make -S -f

# parallel bzip2
# command line file compression tool


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/pbzip2

_src := pbzip2
_bin := $(_src)/pbzip2

_release_ver := 1.1.13
_release_tar := pbzip2-$(_release_ver).tar.gz
_release_tar_url := https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz
_md5_sum := 4cb87da2dba05540afce162f34b3a9a6


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	-$(MAKE) clean -C $(_src)


.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/bin/pbzip2
	rm -f $(PREFIX)/bin/pbzcat
	rm -f $(PREFIX)/bin/pbunzip2
	rm -f $(PREFIX)/share/man/man1/pbzip2.1


.PHONY: download
download: $(_src)


$(_release_tar):
	@# just using -C won't download it
	curl -L -O -C - -o $(_release_tar) $(_release_tar_url)


$(_src): $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; rm $(_release_tar); exit 1) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	make -j -C $(_src) \
		all \
		PREFIX=$(HOME)/.local \
		CXX=g++ \
		LDFLAGS+="-L$$HOME/.local/lib" \
		CXXFLAGS+="-I$$HOME/.local/include"


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -j -C $(_src) \
		install \
		PREFIX=$(HOME)/.local \
		CXX=g++ \
		LDFLAGS+="-L$$HOME/.local/lib" \
		CXXFLAGS+="-I$$HOME/.local/include"
