#!/bin/sh
#
# Licence: Apache2
# Author: Gaetan Trellu - goldyfruit <gaetan.trellu@incloudus.com>
#
# Apply the post-install
for iface in $(ls -1 /sys/class/net | grep -v ^lo$); do
    mac=$(sed 's/:/-/g' /sys/class/net/${iface}/address)
    wget -U "UOI Preseed-Post" -O /target/tmp/preseed-post.sh http://IPADDR:PORT/pxe/fragments/${mac}.post.seed
    if [ $? -eq 0 ]; then
        echo "SET-LOCAL-BOOT|${mac}" > /target/tmp/set-local-boot
        exit 0
    fi
done
