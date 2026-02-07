#!/usr/bin/env make -S -f

# compile LLVM

# LLVM provides tools for compilers / toolchains
# LLVM provides `Clang` for example


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local

_url := https://github.com/llvm/llvm-project.git
# ODIN uses 18 (release/18.x)
# ZIG uses 19 (release/19.x)
# it's ok to compile and install both
_branch ?= release/18.x
_src := llvm-project
_build := $(_src)/build
_bin := $(_build)/bin/clang
_install := $(PREFIX)/bin/clang

# use fewer cores b/c compiling/linkng llvm uses a lot of cpu/ram
_nproc := $(shell echo $$(( `nproc` / 2 + 1)))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# NB: we *could* call clean from ninja/make,
	@#if [ -d "$(_src)" ]; then ninja -C $(_src)/$(_build) clean; fi
	@# *but* this is not reliable (it's a cmake project), so delete the build folder
	rm -rf $(_build)


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_build):
	mkdir -p ./$(_build)

$(_bin): git-hash | $(_build)
	$(call log_info,compiling $@...)
	$(call log_warn,this may take a few minutes...)
	$(call log_info,please wait...)
	$(call check_pkgs,gcc-multilib)
	@# see `LLVM_ALL_PROJECTS`, see llvm.org
	@# test with `ninja -C build check-llvm`
	@# DLLVM_INSTALL_UTILS=ON needed to build FileCheck
	cd $(_src) \
		&& cmake \
			-B build \
			-S llvm \
			-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
			-DLLVM_INSTALL_UTILS=ON \
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
	@# touch the output to prevent repeated installs
	cd $(_src) \
		&& ninja -C build install \
		&& touch $(_install)
