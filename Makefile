SHELL := /bin/bash
VER ?= 3.3.10

clean:
	rm -rvf build
	rm -rvf build/output

prepare:
	mkdir -vp build
	mkdir -vp build/output

prepare_source: prepare
	cd build && mkdir -p source/FeelUOwn
ifeq ("$(wildcard ./build/source/feeluown-$(VER).tar.gz)","")
	cd build/source && wget https://files.pythonhosted.org/packages/source/f/feeluown/feeluown-$(VER).tar.gz &&\
	tar -xzvf feeluown-$(VER).tar.gz -C FeelUOwn
endif
