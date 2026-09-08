#!/bin/bash
#
# Discovers only the flash-based devices Unraid knows about, so that endurance
# items are not created for spinning disks that will never report any.
#
# Unraid's own rotational flag is what decides: it is already correct for every
# device in the array, and using it means nothing has to be probed or woken up
# just to run discovery.

first=1
echo -n '['

while read -r line; do
	if [[ $line == "["* ]]; then
		if [ -n "$id" ] && [ "$rotational" = "0" ]; then
			[ $first = 0 ] && echo -n ","
			first=0
			echo -n '{"{#ID}":'$id'}'
		fi
		id=""
		rotational=""
	else
		IFS="=" read -r key value <<< "$line"
		[ "$key" = "id" ] && [ -n "$value" ] && [ "$value" != '""' ] && id="$value"
		if [ "$key" = "rotational" ]; then
			rotational="${value%\"}"
			rotational="${rotational#\"}"
		fi
	fi
done < <(cat /var/local/emhttp/disks.ini ; echo "[end]")

echo ']'
