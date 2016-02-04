#!/bin/sh
#
# Licence: Apache2
# Author: Gaetan Trellu - goldyfruit <gaetan.trellu@incloudus.com>
#
# Apply the post-install
for iface in $(ls -1 /sys/class/net | grep -v ^lo$); do
    set -- `cat /proc/cmdline`
    for arg in $*; do
        case "$arg" in
            *=*)
                eval $arg;;
        esac
    done
    # Get ks URL arg value
    ksUrl=$(echo ${url%/*})

    # Transform the MAC address
    mac=$(sed 's/:/-/g' /sys/class/net/${iface}/address)

    wget -U "UOI preseed-post" -O /target/tmp/preseed-post.sh ${ksUrl}/fragments/seed/${mac}.post.seed
    if [ $? -eq 0 ]; then
        echo $mac > /target/tmp/mac
        echo "SET-LOCAL-BOOT|${mac}" > /target/tmp/set-local-boot
        exit 0
    fi
done
