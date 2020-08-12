#!/bin/bash
result=$( sensors )
error="$?"
if [ "$error" -gt 0 ]; then
        echo '{"error": "sensors is not installed"}'
        exit 1
fi

echo -n "{"

# CPU temp
line=$( grep 'CPU Temp:' <<< "$result" )
error="$?"
echo -n '"cpu": '
if [ "$error" -eq 0 ]; then
        read _ _ temp _ <<< "$line"
        temp="${temp#+}"
        temp="${temp%°C}"
        echo -n "$temp"
else
        echo -n "null"
fi

# MB
line=$(grep 'MB Temp:' <<< "$result" )
error="$?"
echo -n ', "mainboard": '
if [ "$error" -eq 0 ]; then
        read _ _ temp _ <<< "$line"
        temp="${temp#+}"
        temp="${temp%°C}"
        echo -n "$temp"
else
        echo -n "null"
fi

echo "}"
