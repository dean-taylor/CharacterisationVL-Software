SLICER_VER ?= 4.11
SLICER_URL ?= https://download.slicer.org/download?os=linux&stability=release&version=$(SLICER_VER)

SLICER_NAME := Slicer-$(SLICER_VER)
DEF_FILE ?= Singularity.Slicer
EXECUTABLES := envsubst singularity
SHELL := /bin/bash

K := $(foreach exec,$(EXECUTABLES),\
	$(if $(shell which $(exec)),ok,$(error "$(exec) not in PATH")))

$(HOME)/bin/$(SLICER_NAME) : $(DEF_FILE) $(SLICER_NAME)-linux-amd64.tar.gz $(SLICER_NAME).desktop
	singularity build -F --fakeroot \
		/vol/accs/bin/$(SLICER_NAME) \
		<(SLICER_NAME=$(SLICER_NAME) SLICER_VER=$(SLICER_VER) envsubst '$$SLICER_NAME $$SLICER_VER' <$(DEF_FILE))

$(SLICER_NAME).desktop : Slicer.desktop
	SLICER_NAME=$(SLICER_NAME) SLICER_VER=$(SLICER_VER) envsubst \
		    <Slicer.desktop \
		    >$(SLICER_NAME).desktop

$(SLICER_NAME)-linux-amd64.tar.gz :
	wget -q -O./$(SLICER_NAME)-linux-amd64.tar.gz '$(SLICER_URL)'

.PHONY : clean
clean :
	rm -f Slicer-*-linux-amd64.tar.gz Slicer-*.desktop
