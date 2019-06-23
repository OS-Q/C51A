#!/bin/bash

export WorkPath=`pwd`

## Root Password
for ((i = 0; i < 5; i++)); do
	PASSWD=$(whiptail --title "ESP Config System" \
		--passwordbox "Enter root password. Don't use root or sudo run it" \
		10 60 3>&1 1>&2 2>&3)
	if [ $i = "4" ]; then
		whiptail --title "Note Qitas" --msgbox "Invalid password" 10 40 0	
		exit 0
	fi

	sudo -k
	if sudo -lS &> /dev/null << EOF
$PASSWD
EOF
	then
		i=10
	else
		whiptail --title "ESP Config System" --msgbox "Invalid password, Pls input corrent password" \
		10 40 0	--cancel-button Exit --ok-button Retry
	fi
done

echo $PASSWD | sudo ls &> /dev/null 2>&1

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
	./bootstrap && ./configure --prefix=`pwd`
	make && make install
}

OPTION=$(whiptail --title "Config System" \
	--menu "$MENUSTR" 20 60 12 --cancel-button Finish --ok-button Select \
	"0"   "AUTO" \
	"1"   "update" \
	"2"   "make" \
	3>&1 1>&2 2>&3)
	

if [ $OPTION = '0' ]; then
	clear
	echo -e "AUTO\n${Line}"
	libtool_install
	set_crosstool_ng

	exit 0
elif [ $OPTION = '1' ]; then
	clear
	echo -e "update source\n${Line}"
	set_crosstool_ng
	exit 0
elif [ $OPTION = '2' ]; then
	clear
	echo -e "make\n${Line}"
	
	exit 0
else
	whiptail --title "Config System" \
		--msgbox "Please select correct option" 10 50 0
	exit 0
fi



exit 0
