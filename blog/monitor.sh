#!/usr/bin/env bash
for ((;;))
do
    ps aux | grep 'stlkr-cr' | grep -v grep >> stlkr.cr.stats.txt;
    sleep 5m;
done
