#!/usr/bin/make -f

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

# using 18 b/c this what ODIN uses (note that they use 'main', not 'master')
_branch := release/18.x
# using --depth 1 b/c llvm is very large and we don't need the git history
_depth := 1
# using half the cores b/c compiling/linkng llvm uses a lot of cpu/ram
_nproc := $(shell echo $$(( `nproc` / 2 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	cd $(_src) && ninja -C $(_build) --target clean


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch),$(_depth))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
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
