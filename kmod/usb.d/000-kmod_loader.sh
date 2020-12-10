#!/opt/bin/sh
# Copyright (C) 2015-2018 NDM Systems, McMCC

export LANG=C

echo "/opt/sbin/modprobe" > /proc/sys/kernel/modprobe

# Device - usb:v8564p1000d1100dc00dsc00dp00ic08isc06ip50in00
if [[ -z $usb_vendor ]]; then
    usb_vendor='8564'
fi

if [[ -z $usb_model ]]; then
   usb_model='1000'
fi

VER_KMOD=`uname -r`
NEED_KMOD=`/opt/sbin/modprobe -c | grep -i v${usb_vendor}p${usb_model}d | cut -f3 -d " "`
GET_CLASS=`/opt/sbin/usbdev_get_class 0x${usb_vendor} 0x${usb_model}`
DIR_KMOD=/opt/lib/modules/$VER_KMOD
CHK_ALIAS=$DIR_KMOD/modules.alias
CHK_SYMS=$DIR_KMOD/modules.symbols
CHK_TEST=`/opt/sbin/modinfo $DIR_KMOD/kernel/tfat.ko | grep ^version: | cut -f9 -d " "`
CHK_SAVE=/opt/etc/default/kmod_ndms

if [ ! -d $DIR_KMOD ]; then
	exit 0
fi

if [ ! -f $CHK_ALIAS ] && [ ! -f $CHK_SYMS ]; then
	/opt/sbin/depmod -a 2> /dev/null
	echo $CHK_TEST > $CHK_SAVE
fi

if [ -f $CHK_SAVE ]; then
	if [ "`cat $CHK_SAVE`" != "$CHK_TEST" ]; then
		/opt/sbin/depmod -a 2> /dev/null
		echo $CHK_TEST > $CHK_SAVE
	fi
elif [ -f $CHK_ALIAS ] && [ -f $CHK_SYMS ]; then
	/opt/sbin/depmod -a 2> /dev/null
	echo $CHK_TEST > $CHK_SAVE
fi

if [ "$1" = "start" ]; then

	if [ ! -n "$NEED_KMOD" ] && [ "$usb_subsystem" = "usb_device" ]; then
		if [ -n "$GET_CLASS" ]; then
			for class in $GET_CLASS; do
				case "$class" in
					audio)
						/opt/sbin/modprobe -q snd-usb-audio
						/opt/sbin/modprobe -q snd-usbmidi-lib
					;;
					video)
						/opt/sbin/modprobe -q uvcvideo
					;;
					hid)
						/opt/sbin/modprobe -q usbhid
					;;
				esac
			done
		fi
	fi

	if [ -n "$NEED_KMOD" ]; then
		/opt/sbin/modprobe -q $NEED_KMOD
	fi
fi

exit 0
