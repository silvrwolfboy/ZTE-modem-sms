#!/bin/bash
work_dir="$( cd "$( dirname "$0" )" && pwd )"
i=0
for device in `ls /dev/cu.ZTEUSBATPort_*`
do
	imei=`$work_dir/bin/mget_imei $device`
	if [ $? -ne 0 ]
	then
		echo "[ERROR] Error occured while getting imei numbers"
		exit 1
	fi
	if [ -e $work_dir/sock/$imei ]
	then
		rm -f $work_dir/sock/$imei
	fi
	sudo ln -s $device $work_dir/sock/$imei
	if [ $? -ne 0 ]
	then
		echo "[ERROR] Error occured while creating socket files"
		exit 1
	else
		#echo "[INFO] Create socket in $work_dir/sock/$imei"
		((i++))
	fi
done
echo "[INFO] $i sockets created in dir $work_dir/sock"
cd $work_dir/sock
j=0
for device in `ls`
do
	$work_dir/bin/minit_session $device
	if [ $? -ne 0 ]
	then
		echo  "[ERROR] Error occured on $device init"
		exit 1
	fi
	((j++))
done
echo "[DONE] $j modems initialized"
