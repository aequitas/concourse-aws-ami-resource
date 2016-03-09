#!/bin/sh

set -xe

# inject awscli mock
export PATH="$(dirname $0):$PATH"
export DEBUG=1

input='{"version":{"ImageId": "ami-0123456"}}'

output=$(echo $input | /opt/resource/in /tmp/build/get)

echo $output | jq -er '.version.ImageId == "ami-0123456"'

# test metadata output
echo $output | jq -er '.metadata|map({"key":.name, "value":.value})|from_entries|.Name == "test"'
