#!/bin/bash
result=$( sensors )
error="$?"
if [ "$error" -gt 0 ]; then
        echo '{"error": "sensors is not installed"}'
        exit 1
fi

first_temp() {
	# Prints the first temperature on the given line as a bare number.
	# The unit is deliberately not matched: lm-sensors writes "+54.0°C" or
	# "+54.0 C" depending on the locale of the calling process (the agent
	# runs under LC_ALL=C and gets the latter), and matching the degree
	# sign is itself locale-dependent — under LC_ALL=C it is two bytes, so
	# a regex like "°?C" makes only its second byte optional and never
	# matches. Anchoring on the signed decimal is correct in every locale.
	local line="$1"
	local temp
	temp=$(grep -oE '[+-][0-9]+\.[0-9]+' <<< "$line" | head -1)
	echo "${temp#+}"
}

max_temp() {
        # Prints the highest first_temp value across all given lines, or nothing.
        local max=""
        while IFS= read -r line; do
                [ -z "$line" ] && continue
                local t
                t=$(first_temp "$line")
                [ -z "$t" ] && continue
                if [ -z "$max" ] || awk -v a="$t" -v b="$max" 'BEGIN{exit !(a>b)}'; then
                        max="$t"
                fi
        done <<< "$1"
        echo "$max"
}

echo -n "{"

# CPU: highest core/package reading across all sensor chips.
# Intel coretemp exposes one "Package id N:" line per socket; AMD k10temp uses Tctl/Tdie.
# Older boards that lm-sensors labels directly as "CPU Temp:" are kept as a fallback.
cpu_lines=$(grep -E '^(Package id [0-9]+|Tctl|Tdie):' <<< "$result")
if [ -z "$cpu_lines" ]; then
        cpu_lines=$(grep -E '^CPU Temp:' <<< "$result")
fi
cpu=$(max_temp "$cpu_lines")
echo -n '"cpu": '
if [ -n "$cpu" ]; then
        echo -n "$cpu"
else
        echo -n "null"
fi

# Motherboard: not every board exposes this via lm-sensors, so try the common label
# variants and fall back to null (rather than guessing) when none are present.
mb_line=$(grep -E '^(MB Temp|SYSTIN|System Temp|Motherboard):' <<< "$result" | head -1)
mb=$(first_temp "$mb_line")
echo -n ', "mainboard": '
if [ -n "$mb" ]; then
        echo -n "$mb"
else
        echo -n "null"
fi

echo "}"
