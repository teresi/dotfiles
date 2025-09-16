#!/usr/bin/env make -S -f

# compile LLVM

# LLVM provides tools for compilers / toolchains
# LLVM provides `Clang` for example


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/clang

_url := https://github.com/llvm/llvm-project.git
_src := llvm-project
_build := build
_bin := $(_src)/$(_build)/bin/clang

# ODIN uses 18 (release/18.x)
# ZIG uses 19 (release/19.x)
# it's ok to compile and install both
_branch ?= release/18.x
# using half the cores b/c compiling/linkng llvm uses a lot of cpu/ram
_nproc := $(shell echo $$(( `nproc` / 2 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then ninja -C $(_src)/$(_build) clean; fi


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call log_warn,this may take a few minutes...)
	$(call log_info,please wait...)
	$(call check_pkgs,gcc-multilib)
	$(call check_binary,cmake)
	$(call check_binary,ninja)
	@# see `LLVM_ALL_PROJECTS`, see llvm.org
	@# test with `ninja -C build check-llvm`
	cd $(_src) \
		&& cmake \
			-B build \
			-S llvm \
			-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
			-DCMAKE_BUILD_TYPE=Release \
			-DCLANG_ENABLE_STATIC_ANALYZER=1 \
			-DLLVM_ENABLE_LIBCXX=1 \
			-DLLVM_ENABLE_RUNTIMES=all \
			-DLLVM_ENABLE_PROJECTS="clang;lld;lldb;" \
			-DLLVM_PARALLEL_COMPILE_JOBS=$(_nproc) \
			-DLLVM_PARALLEL_LINK_JOBS=$(_nproc) \
			-G Ninja \
		&& ninja -C build


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ninja -C build install
