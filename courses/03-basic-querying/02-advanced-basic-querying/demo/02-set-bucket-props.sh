#!/bin/bash

echo "$ curl -v 127.0.0.1:8098/buckets/training/props -X PUT -H \"content-type: application/json\" -d '{ \"props\": { \"allow_mult\":true, \"r\":1 } }"

curl -v 127.0.0.1:8098/buckets/training/props -X PUT -H "content-type: application/json" -d '{ "props": { "allow_mult":true, "r":1 } }'

echo -e
