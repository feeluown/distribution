SHELL := /bin/bash
VER ?= $(shell head -n1 version)

default: win64

clean_cache:
	rm -rvf .cache

clean:
	rm -rf build

prepare_source: clean
	mkdir -p build/source
	mkdir -p build/output
	mkdir -p .cache
ifeq ("$(wildcard ./.cache/feeluown-$(VER).tar.gz)","")
	cd ./.cache && pip download "feeluown==$(VER)" -i https://pypi.douban.com/simple
endif
	tar -xzf ./.cache/feeluown-$(VER).tar.gz -C build/source/
	mv build/source/feeluown-$(VER) build/source/FeelUOwn

win64: prepare_source
	cp -rf windows build/
	# Patch source for Windows
	patch --verbose -i build/windows/windows.patch build/source/FeelUOwn/feeluown/plugin.py
	# Fetch libmpv 64bit for Windows
ifeq ("$(wildcard ./.cache/mpv-1.dll)","")
	cd ./.cache &&  curl -L https://github.com/feeluown/FeelUOwn/releases/download/v3.6a0/mpv-1.dll -o mpv-1.dll
endif
	cp -rf .cache/mpv-1.dll build/windows/
	pip install build/source/FeelUOwn
	pip install pyinstaller PyQt5 fuo-local fuo-netease fuo-qqmusic fuo-kuwo
	cp -rf build/source/FeelUOwn/feeluown/icons/feeluown.ico build/windows
	cd build/windows && set PYTHONOPTIMIZE=1 && pyinstaller --onedir feeluown.spec
	mkdir -vp build/output/windows
	powershell Compress-Archive build/windows/dist/feeluown build/output/windows/FeelUOwn-Win64.zip
