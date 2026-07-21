#!/bin/bash

UPS="ups@127.0.0.1"
DATA=$(upsc "$UPS" 2>/dev/null)

if [ -z "$DATA" ]; then
	echo '{"connected":false}'
	exit 0
fi

echo -n '{"connected":true'
while IFS=':' read -r key value; do
	value="${value# }"
	case "$key" in
		"ups.status") echo -n ", \"status\":\"$value\"" ;;
		"ups.load") echo -n ", \"loadpct\":$value" ;;
		"battery.charge") echo -n ", \"bcharge\":$value" ;;
		"battery.runtime") echo -n ", \"timeleft\":$value" ;;
		"battery.voltage") echo -n ", \"battv\":$value" ;;
		"input.voltage") echo -n ", \"linev\":$value" ;;
	esac
done <<< "$DATA"
echo "}"
