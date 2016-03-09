#!/bin/sh

cd $(dirname $0)
for test in $(ls */test.sh);do
    log=$(mktemp /tmp/test-log.XXXXXX)
    exec 3>&2 # make stderr available as fd 3 for the result
    exec 2>$log

    echo running $test
    $test || cat $log 1>&3
done
