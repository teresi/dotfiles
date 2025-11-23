#!/usr/bin/env make -S -f

# install texlive
#
# REQUIRES perl, tar, curl
#
# installs, e.g.:
#	pdflatex tlmgr latexmk
#
# MAGIC: texlive installs binaries to TEXDIR/bin/x86_64-linux,
#       but will change depending on your setup
#
# SEE: https://wiki.debian.org/TeXLive
# SEE: https://www.tug.org/texlive/doc/install-tl.html
# SEE: https://en.wikibooks.org/wiki/LaTeX/Installation
# SEE: https://tug.org/texlive/doc/texlive-en/texlive-en.html#x1-50001.3

include ../helpers.mk
BASHRC ?= $(HOME)/.bashrc

# MAGIC: texdir is typically $HOME/.texlive2024, by LaTeX convention
# I don't track the year b/c the installer will download the latest year
TEXDIR ?= $(HOME)/.texlive
# MAGIC: paper size is letter in US
PAPER ?= letter
# MAGIC: schemes, e.g.:  scheme-basic | scheme-small | scheme-medium
# basic includes "plain and latex", use a small package to save time,
# we use tlmgr to install dependencies later
SCHEME ?= scheme-basic


_tar_url := https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
_tar := install-tl-unx.tar.gz
_installer := install-tl
_sig_url := https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz.sha512
_sig := install-tl-unx.tar.gz.sha512
# MAGIC: default directory on my systems
_texlive_bin := $(TEXDIR)/bin/x86_64-linux
# MAGIC: my convention, location of extra bash file w/ LaTeX variables
_bashrc_tex := $(HOME)/.config/source_texlive.bash


# append a 'source $3' call to a file $1
#      Appends the line if it does *not* exist
#      Uses the magic keyword as a comment (# delimited) to test if the call exists
#      1    filepath to append to
#      2    magic keyword
#      3    filepath to source
define source_file
	grep -q $(2) $(1) || echo "[ -r $(3) ] && source $(3)  # $(2)" >> $(1)
endef



.PHONY: all
all: $(_installer)


.PHONY: clean
clean:
	rm -rf $(_installer)
	rm -rf $(_bashrc_tex)
	rm -rf $(_sig)
	rm -rf $(_tar)


.PHONY: install
install: $(_texlive_bin) $(_bashrc_tex)


.PHONY: uninstall
uninstall:
	rm -rf $(TEXDIR)
	rm -f $(_bashrc_tex)


.PHONY: download
download: $(_tar) $(_sig)


$(_sig):
	curl -L -o $(_sig) $(_sig_url)


$(_tar):
	curl -L -o $(_tar) $(_tar_url)


$(_installer): $(_tar) $(_sig)
	@# touch the decompressed file b/c it's timestamp is not it's decompress time
	@# tar -C <output> is used to keep things consistent, otherwise it outputs install-tl-YYYYMMDD
	sha512sum -c $(_sig) \
		&& echo "signature check PASSED, unpacking installer..." \
		&& (mkdir -p $(_installer) \
		&& tar -xvzf $(_tar) -C $(_installer) \
		&& touch $(_installer)) \
		|| (echo "could not validate checksum!!! $(_sig)"; rm $(_tar); rm $(_sig); exit 1)


$(_texlive_bin): $(_installer)
	$(call log_info,updating $@...)
	@# cd into install-tl* b/c there is a sub dir starting with install-tl-2024* that is unkown
	cd $(_installer) && cd install-tl-* && \
		perl install-tl \
		-gui text \
		--paper=$(PAPER) \
		--texdir $(TEXDIR) \
		--scheme $(SCHEME) \
		-no-interaction
	@# touch the folder b/c it's timestamp is not the install time
	touch $(_texlive_bin)
	$(call log_info,installing common packages with tlmgr...)
	$(_texlive_bin)/tlmgr install latexmk enumitem


$(_bashrc_tex): $(_texlive_bin)
	$(call log_info,updating bash scripts to setup your paths...)
	mkdir -p $(HOME)/.config
	echo "MANPATH+=:$(TEXDIR)/texmf-dist/doc/man" > $(_bashrc_tex)
	echo "INFOPATH+=:$(TEXDIR)/texmf-dist/doc/info" >> $(_bashrc_tex)
	echo "PATH+=:$(_texlive_bin)" >> $(_bashrc_tex)
	$(call source_file,$(BASHRC),TEXLIVE,$(_bashrc_tex))
