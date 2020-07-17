#!/bin/bash

id="$1"
found=0
device=""

data_size=0
data_free=0
data_used=0

cache_size=0
cache_free=0
cache_used=0

while read line; do
	if [[ $line == "["* ]]; then
		if [ "$type" = "Cache" ]; then
			cache_size=$(( $cache_size + $size ))
			cache_free=$(( $cache_free + $free ))
		elif [ "$type" = "Data" ]; then
			data_size=$(( $data_size + $size ))
			data_free=$(( $data_free + $free ))
		fi
		type=""
		size=0
		free=0
	else
		IFS="=" read key value <<< "$line"
			value="${value%\"}"
			value="${value#\"}"
			[ $key = "type" ] && type="$value"
			[ $key = "fsSize" ] && size=$(( $value * 1024 ))
			[ $key = "fsFree" ] && free=$(( $value * 1024 ))
	fi
done < <(cat /var/local/emhttp/disks.ini ; echo "[empty]")

echo -n '{"data": {"size":'$data_size ', "free":'$data_free ', "used":'$(( $data_size  - $data_free  ))'},'
echo    ' "cache":{"size":'$cache_size', "free":'$cache_free', "used":'$(( $cache_size - $cache_free ))'}}'
