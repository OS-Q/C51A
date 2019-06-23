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
	sudo apt install -y gcc wget make flex bison gperf gawk grep help2man
	sudo apt install -y gettext automake flex texinfo libtool libtool-bin libncurses-dev 
	sudo apt install -y python python-dev python-pip python-setuptools python-serial python-cryptography python-future
	sudo apt autoremove -y 
}

function chmod_config()
{
	chmod +x ./crosstool-NG/bootstrap
	chmod +x ./crosstool-NG/configure
	chmod +x ./crosstool-NG/lib/crosstool-ng/scripts/*
}

OPTION=$(whiptail --title "Config System" \
	--menu "$MENUSTR" 20 60 12 --cancel-button Finish --ok-button Select \
	"0"   "AUTO" \
	"1"   "update" \
	"2"   "make" \
	3>&1 1>&2 2>&3)
	

if [ $OPTION = '0' ]; then
	clear
	echo -e "AUTO all\n${Line}"
	apt_install
	chmod_config
	set_esp8266
	set_esp8266_sdk
	set_esp8266_rtos
	exit 0
elif [ $OPTION = '1' ]; then
	clear
	echo -e "update source\n${Line}"
	set_esp8266
	exit 0
elif [ $OPTION = '2' ]; then
	clear
	echo -e "make\n${Line}"
	set_esp32
	exit 0
else
	whiptail --title "Config System" \
		--msgbox "Please select correct option" 10 50 0
	exit 0
fi



exit 0
