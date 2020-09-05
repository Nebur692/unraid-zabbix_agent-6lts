#!/bin/bash

id="$1"
found=0
device=""

while read line; do
	if [[ $line == "["* ]]; then
		if [ $found = 1 ]; then
			[ $fsFree -ge 0 ] && [ $fsSize -ge 0 ] && fsUsed=$(( $fsSize - $fsFree ))
			echo -n '{"device":"'$device'", "name":"'$name'", "status":"'$status'", "temp":'$temp', "size":'$size', "num_reads":'$num_reads', '
			echo -n '"num_writes":'$num_writes', "num_errors":'$num_errors', "type":"'$type'", "fs_size":'$fsSize', "fs_free":'$fsFree', "fs_used":'$fsUsed', "running":'$running', '
			break
		else
			device=''
			name=''
			status=''
			temp=-1
			size=-1
			num_reads=-1
			num_writes=-1
			num_errors=-1
			type=""
			fsSize=-1
			fsFree=-1
			fsUsed=-1
			running=-1
		fi
	else
		while IFS="=" read key value; do
			value="${value%\"}"
			value="${value#\"}"
			[ $key = "id" ] && [ "$value" = "$id" ] && found=1
			[ $key = "device" ] && device="$value"
			[ $key = "name" ] && name="$value"
			[ $key = "status" ] && status="$value"
			[ $key = "temp" ] && [ "$value" != "*" ] && temp="$value"
			[ $key = "size" ] && size=$(( $value * 1024 ))
			[ $key = "numReads" ] && num_reads="$value"
			[ $key = "numWrites" ] && num_writes="$value"
			[ $key = "numErrors" ] && num_errors="$value"
			[ $key = "type" ] && type="$value"
			[ $key = "fsSize" ] && fsSize=$(( $value * 1024 ))
			[ $key = "fsFree" ] && fsFree=$(( $value * 1024 ))
			if [ $key = "color" ]; then
				case "$value" in
					green-on) running=1;;
					green-blink) running=0;;
				esac
			fi
		done <<< "$line"
	fi
done < <(cat /var/local/emhttp/disks.ini ; echo "[empty]")

if [ $found = 0 ]; then
	echo "UNSUPPORTED"
	exit 1
fi

read bytes_read bytes_written _ < <(grep $device"=" /var/local/emhttp/diskload.ini | cut -d"=" -f2)
echo '"bytes_reading":'$bytes_read', "bytes_writing":'$bytes_written'}'
