#!/bin/bash
#
# Reports SSD/NVMe endurance data for a given Unraid disk id.
#
# Output (JSON):
#   supported : 1 if the device reported endurance data, 0 otherwise
#   wear      : percentage of the manufacturer's rated endurance consumed
#               (100 = rated TBW reached; the drive is not dead, but the
#               manufacturer no longer guarantees it). -1 if unknown.
#   written   : total bytes ever written to the device. -1 if unknown.
#
# Spinning disks are skipped using Unraid's own rotational flag, and a disk
# that is currently spun down is never touched: waking a sleeping array to
# read a counter that moves once a month would cost far more than the data
# is worth. smartctl is additionally called with -n standby as a safety net.
#
# Results are cached, for the same reason. The TTL is deliberately shorter
# than the hourly poll interval of the item: if the two matched, any jitter
# in the poll would serve a cached value, make the delta come out as zero and
# report a write rate that never happened.

id="$1"
CACHE_DIR="/var/tmp/zabbix_agent_ssd"
CACHE_TTL=1800
DISKS_INI="/var/local/emhttp/disks.ini"

unsupported='{"supported":0, "wear":-1, "written":-1}'

[ -z "$id" ] && { echo "$unsupported"; exit 0; }
[ -r "$DISKS_INI" ] || { echo "$unsupported"; exit 0; }

# Pull the one section whose id matches, and read the fields we need from it.
# Fields are not in a fixed order within a section, so the whole block is
# collected before deciding.
eval "$(awk -F= -v want="$id" '
	/^\[/ { if (matched) exit; device=""; rotational=""; spundown=""; matched=0; next }
	{
		key=$1; value=$2
		gsub(/"/, "", value)
		if (key == "device")     device=value
		if (key == "rotational") rotational=value
		if (key == "spundown")   spundown=value
		if (key == "id" && value == want) matched=1
	}
	END {
		if (matched) {
			printf "device=%s\nrotational=%s\nspundown=%s\n", device, rotational, spundown
		}
	}
' "$DISKS_INI")"

[ -z "$device" ] && { echo "$unsupported"; exit 0; }
[ "$rotational" = "1" ] && { echo "$unsupported"; exit 0; }
[ "$spundown" = "1" ] && { echo "$unsupported"; exit 0; }

cache="$CACHE_DIR/$device"
if [ -f "$cache" ]; then
	age=$(( $(date +%s) - $(stat -c %Y "$cache" 2>/dev/null || echo 0) ))
	if [ "$age" -lt "$CACHE_TTL" ]; then
		cat "$cache"
		exit 0
	fi
fi

wear=""
written=""

if [ -b "/dev/$device" ]; then
	smart=$(smartctl -A -n standby "/dev/$device" 2>/dev/null)

	if [ -n "$smart" ]; then
		# NVMe: both fields are defined by the NVMe spec, so this is reliable.
		wear=$(awk -F: '/Percentage Used/{gsub(/[^0-9]/,"",$2); print $2; exit}' <<< "$smart")
		units=$(awk '/Data Units Written/{gsub(/,/,"",$4); print $4; exit}' <<< "$smart")
		# One NVMe data unit is 1000 * 512 bytes.
		[ -n "$units" ] && written=$(awk -v u="$units" 'BEGIN{printf "%.0f", u*512000}')

		# SATA SSDs: there is no standard here and vendors disagree, so try
		# the attributes seen in practice and give up rather than guess.
		[ -z "$wear" ] && wear=$(awk '/Percent_Lifetime_Remain|Percent_Life_Remaining|SSD_Life_Left|Media_Wearout_Indicator/{print 100-$4; exit}' <<< "$smart")
		[ -z "$wear" ] && wear=$(awk '/Percent_Lifetime_Used|SSD_Life_Used/{print $4+0; exit}' <<< "$smart")

		if [ -z "$written" ]; then
			lbas=$(awk '/Total_LBAs_Written|Total_Writes_GiB/{print $10; exit}' <<< "$smart")
			if [ -n "$lbas" ] && [ "$lbas" -gt 0 ] 2>/dev/null; then
				written=$(awk -v l="$lbas" 'BEGIN{printf "%.0f", l*512}')
			fi
		fi
	fi
fi

[ -z "$wear" ] && wear=-1
[ -z "$written" ] && written=-1

if [ "$wear" != "-1" ] || [ "$written" != "-1" ]; then
	supported=1
else
	supported=0
fi

result='{"supported":'$supported', "wear":'$wear', "written":'$written'}'

mkdir -p "$CACHE_DIR" 2>/dev/null
echo "$result" > "$cache" 2>/dev/null

echo "$result"
