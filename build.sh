#!/bin/bash

export WorkPath=`pwd`


function apt_install()
{
	sudo apt install -y gcc wget make gperf bison flex texinfo help2man gawk automake libncurses5-dev
	sudo apt install -y sed bash cut dpkg-dev patch texinfo m4 libtool stat cvs websvn tar gzip bzip2 lzma readlink patch gcj cvsd
	sudo apt autoremove -y
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
	./configure
	make
	sudo make install
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

function get_source()
{
	if [ ! -d $WorkPath/crosstool-NG ]; then
		cd $WorkPath/crosstool-NG/.build/tarballs
		wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
		wget http://www.bastoul.net/cloog/pages/download/cloog-0.18.4.tar.gz
	fi

}

function make_xtensa_lx106()
{
	cd $WorkPath/crosstool-NG
	./ct-ng xtensa-lx106-elf
	./ct-ng build
}


echo -e "AUTO\n${Line}"
libtool_install
set_crosstool_ng
make_xtensa_lx106

exit 0
