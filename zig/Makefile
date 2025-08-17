#!/usr/bin/make -f

# compile Zig

# a general-purpose language
# requires cmake, clang, llvm, llvd 19.x

include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/ziglang/zig.git
_src := zig
_build := $(_src)/build
_bin := $(_build)/stage3/bin/zig
_branch := master
_install := $(PREFIX)/bin/zig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_build)" ]; then $(MAKE) -ik -C $(_build) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: repo


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_build) install


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_binary, cmake clang)
	mkdir -p $(_build)
	cd $(_build) && \
		cmake --install-prefix=$(PREFIX) ..
	$(MAKE) -ik -C $(_build) -j


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
