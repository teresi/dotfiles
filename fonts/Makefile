#!/usr/bin/env make -S -f

# install fonts
#
# on Ubuntu, the user's fonts are stored in ~/.local/share/fonts
#   and you use fc-cache to update the machine's fonts


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local
SHARE := $(PREFIX)/share/fonts

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PARENT := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0

SOURCES :=
SOURCES += FiraCode.zip
SOURCES += FiraMono.zip
SOURCES += UbuntuMono.zip
SOURCES += DejaVuSansMono.zip

FONTS := $(patsubst %.zip,$(SHARE)/%,$(SOURCES))

# empty target to track the cache
FC_CACHE := is_fc_cache_updated


.PHONY: all
all: $(SOURCES)


.PHONY: clean
clean:
	rm -rf *.zip


.PHONY: uninstall
uninstall:
	$(call log_info,uninstalling fonts...)
	rm -rf $(FONTS)
	$(call log_info,updating font cache... please wait...)
	fc-cache -f


.PHONY: install
install: all $(FC_CACHE)


$(SHARE):
	mkdir -p $(SHARE)


%.zip:
	$(call log_info,downloading font $@...)
	curl -L -O -C - $(PARENT)/$@


$(SHARE)/% : %.zip | $(SHARE)
	$(call log_info,installing font $@...)
	unzip -o $< -d $(SHARE)/$*


$(FC_CACHE) &: $(FONTS)
	$(call log_info,updating font cache... please wait...)
	@# this is a grouped target b/c fc-cache reads all the fonts
	fc-cache -f
	touch $(FC_CACHE)
