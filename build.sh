#!/bin/bash
VERSION=`xpath -q -e 'string(//PLUGIN/@version)' zabbix_agent.plg`
FILE="zabbix_agent-$VERSION.package.tgz"
echo "Version in plugin file: $VERSION"
echo "Generated file will be: $FILE"
echo "Is this correct? If yes, press Enter. If not, press Ctrl-C."
read

echo "Creating $FILE..."
echo
tar -czvf "$FILE" files
echo
read md5 _ < <(md5sum "$FILE")
echo "MD5 of the resulting file for the plugin file: $md5"
