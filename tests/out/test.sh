#!/bin/sh

set -xe

# inject awscli mock
export PATH="$(realpath $(dirname $0)):$PATH"
export DEBUG=1

# test output with terminating instance

input='{"params":{"name": "test", "terminate": true}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id

touch /tmp/i-12345678
output=$(echo $input | /opt/resource/out /tmp/build/put)
test ! -f /tmp/i-12345678

echo $output | jq -er '.version.ImageId == "ami-0123456"'

# test output without terminating instance

input='{"params":{"name": "test"}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id

touch /tmp/i-12345678
output=$(echo $input | /opt/resource/out /tmp/build/put)
test -f /tmp/i-12345678

echo $output | jq -er '.version.ImageId == "ami-0123456"'

# test metadata output
echo $output | jq -er '.metadata|map({"key":.name, "value":.value})|from_entries|.Name == "test"'
