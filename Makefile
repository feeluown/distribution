SHELL := /bin/bash
VER ?= $(shell head -n1 version)

clean_cache:
	rm -rvf .cache

clean:
	rm -rvf build
	rm -rvf build/output

prepare:
	mkdir -vp build
	mkdir -vp build/output
	mkdir -vp .cache

prepare_source: prepare
	cd build && mkdir -p source/FeelUOwn
ifeq ("$(wildcard ./.cache/feeluown-$(VER).tar.gz)","")
	cd ./.cache && wget -c https://files.pythonhosted.org/packages/source/f/feeluown/feeluown-$(VER).tar.gz
endif
	cd ./.cache && tar -xzvf feeluown-$(VER).tar.gz -C ../build/source/FeelUOwn

win64: prepare_source
	cp -rvf windows build/
	# Patch source for Windows
	patch --verbose -i build/windows/windows.patch build/source/FeelUOwn/feeluown-$(VER)/feeluown/plugin.py
	# Fetch libmpv 64bit for Windows
ifeq ("$(wildcard ./.cache/mpv-1.dll)","")
	cd ./.cache && wget -c https://github.com/feeluown/FeelUOwn/releases/download/v3.6a0/mpv-1.dll
endif
	cp -rvf .cache/mpv-1.dll build/windows/
	pip install "pyinstaller<4.0" PyQt5 fuo-local fuo-netease fuo-xiami fuo-qqmusic fuo-kuwo
	mv build/source/FeelUOwn/feeluown-$(VER)/* build/source/FeelUOwn/
	pip install build/source/FeelUOwn
	cd build/windows && cp -rvf ../source/FeelUOwn/feeluown/icons/feeluown.ico ./ && set PYTHONOPTIMIZE=1 && pyinstaller -i feeluown.ico --onedir feeluown.spec
	mkdir -vp build/output/windows
	powershell Compress-Archive build/windows/dist/feeluown build/output/windows/FeelUOwn-Win64.zip
