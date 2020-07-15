#!/bin/bash
first=1

echo -n "["
while read name; do
	[ "$name" = "" ] && continue
	[ $first = 0 ] && echo -n ","
	first=0
	echo -n '{"{#VM}":"'$name'"}'
done < <(virsh list --name --all)
echo "]"
