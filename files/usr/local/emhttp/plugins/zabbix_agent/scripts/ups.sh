#!/bin/bash

echo -n '{"connected":true'
apcaccess | while read key _ value unit _; do
	#echo $key - $value - $unit
	case "$key" in
		"STATUS") echo -n ", \"status\":\"$value\"" ;;
		"LOADPCT") echo -n ", \"loadpct\":$value" ;;
		"BCHARGE") echo -n ", \"bcharge\":$value" ;;
		"TIMELEFT") echo -n ", \"timeleft\":$value" ;;
		"BATTV") echo -n ", \"battv\":$value" ;;
		"LINEV") echo -n ", \"linev\":$value" ;;
	esac
done
echo "}"
