#!/bin/sh
#
# Licence: Apache2
# Author: Gaetan Trellu - goldyfruit <gaetan.trellu@incloudus.com>
#
# Detect distribution (Debian / Ubuntu)
# Detect version (testing, Jessie, Wily, etc...)
for iface in $(ls -1 /sys/class/net | grep -v ^lo$); do
    set -- `cat /proc/cmdline`
    for arg in $*; do
        case "$arg" in
            *=*)
                eval $arg;;
        esac
    done
    # Get ks URL arg value
    ksUrl=$(echo ${url%/*/*})

    # Transform the MAC address
    mac=$(sed 's/:/-/g' /sys/class/net/${iface}/address)

    # Get the post-preseed file to get the "version" variable
    wget -U "UOI detect-version" -O /tmp/preseed-post.sh ${ksUrl}/fragments/seed/${mac}.post.seed
    if [ $? -eq 0 ]; then
        distribution=$(grep "version=" /tmp/preseed-post.sh | awk -F"=" '{ print $2 }' | awk -F"-" '{ print $1 }')
        version=$(grep "version=" /tmp/preseed-post.sh | awk -F"=" '{ print $2 }' | awk -F"-" '{ print $2 }')
        echo "d-i mirror/http/directory string /${distribution}/" > /tmp/mirror.conf
        echo "d-i mirror/suite string $version" >> /tmp/mirror.conf
        debconf-set-selections /tmp/mirror.conf
        exit 0
    fi
done
