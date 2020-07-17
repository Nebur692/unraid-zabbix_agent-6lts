#!/bin/bash
VM="$1"

echo -n '{'
state=`virsh domstate "$VM"`
echo -n '"state":"'$state'"'
if [ "$state" != "running" ]; then
	echo -n '}'
	exit
fi

while IFS=":" read key value; do
	[ "$key" = "CPU(s)" ] && echo -n ', "cpus":'$value
	[ "$key" = "CPU time" ] && echo -n ', "cpu_time":'${value%s}
	[ "$key" = "Max memory" ] && echo -n ', "memory_max":'$((${value%KiB} * 1024))
	[ "$key" = "Used memory" ] && echo -n ', "memory_used":'$((${value%KiB} * 1024))
done < <(virsh dominfo "$VM")

while read if key value; do
	[ "$key" = "rx_bytes" ] && echo -n ', "network_bytes_in":'$value
	[ "$key" = "tx_bytes" ] && echo -n ', "network_bytes_out":'$value
done < <(virsh domifstat "$VM" vnet0)

echo "}"
