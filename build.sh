#!/bin/bash

export WorkPath=`pwd`


function apt_install()
{
	sudo apt install -y gcc wget make gperf bison flex texinfo help2man gawk automake libncurses5-dev
	sudo apt install -y sed bash cut dpkg-dev patch texinfo m4 libtool stat cvs websvn tar gzip bzip2 lzma readlink patch gcj cvsd
}

function libtool_install()
{
	cd $WorkPath
	sudo apt install -y gcc wget make
	sudo apt remove -y libtool
	wget -O libtool.tar.gz ftp://ftp.gnu.org/gnu/libtool/libtool-1.5.26.tar.gz
	mkdir libtool
	tar -xzvf libtool.tar.gz  -C libtool --strip-components 1
	cd libtool
	sudo ./configure && make && sudo make install
}

function set_crosstool_ng()
{
	if [ ! -d $WorkPath/crosstool-NG ]; then
		cd $WorkPath
		#wget https://codeload.github.com/crosstool-ng/crosstool-ng/tar.gz/crosstool-ng-1.24.0
		#git clone --depth=1 https://github.com/crosstool-ng/crosstool-ng
		git clone --depth=1 -b lx106 git://github.com/jcmvbkbc/crosstool-NG.git
	fi
	cd crosstool-NG
	chmod +x ./bootstrap
	chmod +x ./configure
	sudo ./bootstrap && ./configure --prefix=`pwd`
	make && make install
}

function build_xtensa_lx106()
{
	if [ -x $WorkPath/crosstool-NG/ct-ng ]; then
		sudo $WorkPath/crosstool-NG/ct-ng xtensa-lx106-elf
		sudo $WorkPath/crosstool-NG/ct-ng build
	fi
}

apt_install
libtool_install
set_crosstool_ng
build_xtensa_lx106
