#!/bin/bash -e
n=1
if [ $# -lt 0 ]; then echo "Usage $0 [count]"; exit 2; fi
if [ -n "$1" ] ; then n=$1 ; fi
while read name sql
do
    if [[ "$name" =~ "#" ]] ; then continue ; fi
    for i in $(seq 1 $n) ; do
        t=$(( time -p ( echo $sql | bq query --nouse_cache) 2>&1 ) | grep real | sed -e 's/real *//')
        echo "$name $t"
    done
done < queries-bigquery.sql
