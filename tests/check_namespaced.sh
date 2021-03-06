#!/bin/sh

packets=99
cmd="./udp_send 1337 $packets"
filter="udp port 1337"

# start sending packages non-namespaced
 ./udp_send 1337 -1 &

# make sure we only capture the packets from the namespaced version
sudo ../src/nsntrace -d lo -f "$filter" $cmd | grep "$packets packets" || {
    echo "Did not capture $packets packets!"
    exit 1
}

# stop the non-namespaced udp_send
kill $(pidof udp_send)

exit 0
