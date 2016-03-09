#!/bin/sh

set -xe

# inject awscli mock
export PATH="$(realpath $(dirname $0)):$PATH"
export DEBUG=1

input='{"params":{"name": "test"}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id

output=$(echo $input | /opt/resource/out /tmp/build/put)

echo $output | jq -er '.version.ImageId == "ami-0123456"'
