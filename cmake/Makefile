#!/usr/bin/env make -S -f

# compile CMake


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/Kitware/CMake.git
_src := cmake
_branch := v4.2.3
_build := $(_src)/build
_bin := $(_build)/bin/cmake
_install := $(PREFIX)/bin/cmake


.PHONY: all
all: $(_build)/bin/cmake


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# NB: we *could* call clean from the build folder
	@#if [ -d "$(_src)" ]; then make -C $(_build) clean; fi
	@# *but* this is not reliable (it's a cmake project), so delete the build folder
	rm -rf $(_build)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) uninstall; fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_build):
	mkdir -p $(_build)


$(_bin): git-hash | $(_build)
	$(call log_info,updating $@...)
	@# the new openssl installs to lib64
	@# NOTE: previously used system curl else the cmake's curl will use the wrong headers for openssl
	@#         using the flag --system-curl
	cd $(_build) \
		&& PKG_CONFIG_PATH="${HOME}/.local/lib64/pkgconfig:${HOME}/.local/lib/pkgconfig:${PKG_CONFIG_PATH}" \
		../bootstrap \
			--prefix=$(PREFIX) \
			--parallel=$(shell nproc) \
			-- \
			-DCMAKE_BUILD_TYPE=RELEASE \
			-DCMAKE_PREFIX_PATH=$(PREFIX) \
			-DCMAKE_C_FLAGS="-I${HOME}/.local/include" \
			-DCMAKE_CXX_FLAGS="-I${HOME}/.local/include" \
			-DCMAKE_EXE_LINKER_FLAGS="-L${HOME}/.local/lib64 -L${HOME}/.local/lib -Wl,-rpath,${HOME}/.local/lib64 -Wl,-rpath,${HOME}/.local/lib"

	@# NB using a low core count b/c cmake uses a lot of ram per core
	$(MAKE) -ik -j 3 -C $(_build)
	$(call log_info,updating $@...    COMPLETE!)


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -j 3 -C $(_build) install && touch $(_bin)
	$(call log_info,updating $@...    COMPLETE!)
