#!/bin/sh

set -xe

# inject awscli mock
export PATH="$(realpath $(dirname $0)):$PATH"
export DEBUG=1

## test output with terminating instance

input='{"params":{"name_from": "name_file", "terminate": true}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id
echo "1234" > /tmp/build/put/name_file

touch /tmp/i-12345678
output=$(echo $input | /opt/resource/out /tmp/build/put)

# instance should have been deleted
test ! -f /tmp/i-12345678

# output should contain ami id
echo $output | jq -er '.version.ImageId == "ami-0123456"'

## test output without terminating instance

input='{"params":{"name_from": "name_file"}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id
echo "1234" > /tmp/build/put/name_file

touch /tmp/i-12345678
output=$(echo $input | /opt/resource/out /tmp/build/put)

# instance should not have been deleted
test -f /tmp/i-12345678

# output should contain ami id
echo $output | jq -er '.version.ImageId == "ami-0123456"'

# test metadata output
echo $output | jq -er '.metadata|map({"key":.name, "value":.value})|from_entries|.Name == "1234"'

## test output only terinating image

input='{"params":{"terminate": true}}'

mkdir -p /tmp/build/put/ami-id/
echo "i-12345678" > /tmp/build/put/ami-id/id

touch /tmp/i-12345678
output=$(echo $input | /opt/resource/out /tmp/build/put)

# instance should have been deleted
test ! -f /tmp/i-12345678

# output should not contain ami id or metadata
echo $output | jq -er '.version == {}'
echo $output | jq -er '.metadata == {}'
