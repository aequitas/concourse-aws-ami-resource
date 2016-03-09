#!/bin/sh

set -xe

# inject awscli mock
export PATH="$(dirname $0):$PATH"
export DEBUG=1

input='{"version":{"ImageId": "ami-0123456"}}'

output=$(echo $input | /opt/resource/in /tmp/build/get)

echo $output | jq -er '.version == "ami-0123456"'
