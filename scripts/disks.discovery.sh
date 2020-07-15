#!/bin/bash
id='""'
device='""'
first=1

echo -n '['

while IFS="=" read key value; do
	if [ "$key" = "id" ] && [ -n "$value" ] && [ "$value" != '""' ]; then
		[ $first = 0 ] && echo -n ","
		first=0
		echo -n '{"{#ID}":'$value'}'
	fi
done < /var/local/emhttp/disks.ini

echo ']'
