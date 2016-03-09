#!/bin/sh

cd $(dirname $0)
for test in $(ls */test.sh);do
    log=$(mktemp /tmp/test-log.XXXXXX)

    echo running $test
    if ! $test 2>$log;then
        cat $log 1>&2
        exit 1
    fi
done
