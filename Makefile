clean:
	rm -rvf build
	rm -rvf build/output

prepare:
	mkdir -vp build
	mkdir -vp build/output

linux: prepare
	mkdir -vp build/linux
	mkdir -vp build/output/linux

archlinux: linux
	mkdir -vp build/linux/archlinux
	mkdir -vp build/output/linux/archlinux
	cp linux/archlinux/* build/linux/archlinux/
	cd build/linux/archlinux && makepkg -Cfsr && cp -vf feeluown*.pkg.tar* ../../../build/output/linux/archlinux/
