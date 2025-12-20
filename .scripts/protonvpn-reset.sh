#!/usr/bin/bash

while true;
do
    protonvpn connect
    sleep 180
    echo "Loop Done"
    protonvpn disconnect
done

