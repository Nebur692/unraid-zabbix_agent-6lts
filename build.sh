#!/bin/bash
VERSION=`xpath -q -e 'string(//PLUGIN/@version)' zabbix_agent.plg`
FILE="zabbix_agent-$VERSION-x86_64-1.txz"
echo "Version in plugin file: $VERSION"
echo "Generated file will be: $FILE"

if [ -e "$FILE" ]; then
	echo
	echo "File already exists."
	
	givenMD5=`xpath -q -e 'string(//PLUGIN/@packageMD5)' zabbix_agent.plg`
	read currentMD5 _ < <(md5sum "$FILE")
	
	if [ "$givenMD5" = "$currentMD5" ]; then
		echo "MD5 value is OK."
	else
		echo "MD5 value does not match!"
		echo "unraid_zabbix.plg: $givenMD5"
		echo "$FILE: $currentMD5"
	fi
	
	echo
	
	if [ "$1" != "--force" ]; then
		echo "Stopping now. Call '$0 --force' to force recreating the file."
		exit 1
	fi
fi

echo "Is this correct? If yes, press Enter. If not, press Ctrl-C."
read

echo "Creating $FILE..."
echo
tar -cv --owner=root --group=root --lzma -C files -f "$FILE" .
echo
read md5 _ < <(md5sum "$FILE")
echo "MD5 of the resulting file for the plugin file: $md5"
echo "Run this tool again to validate the MD5 value from the plugin file."
