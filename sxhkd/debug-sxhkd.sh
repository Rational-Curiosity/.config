#!/bin/sh
while read EVENT
do
    echo "<<<$EVENT>>>"
done < ~/.config/polybar/keys.fifo