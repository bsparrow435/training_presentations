# Basic Querying - Advanced Basic Querying

## Requests Through Failures

Start a cluster with at least 3 nodes.

Store an object:

    curl -v 127.0.01:8098/buckets/training/keys/test\?returnbody=true\&pw=1 -X PUT -H "content-type: text/plain" -d "testing"

Stop two nodes, and then execute the following requests:

    curl -v 127.0.0.1:8098/buckets/training/keys/test\?pr=3

    curl -v 127.0.0.1:8098/buckets/training/keys/test\?r=3


## Getting and Setting Bucket Properties

  - Get:

        curl -v 127.0.0.1:8098/buckets/training/props

  - Set:

        curl -v 127.0.0.1:8098/buckets/training/props -X PUT -H "content-type: application/json" -d '{ "props": { "allow_mult":true, "r":1 } }'

## Siblings

  - Create Siblings:

        curl -v 127.0.0.1:8098/buckets/training/keys/test\?returnbody=true -X PUT -H "content-type: text/plain" -d "sibling"

  - Resolve Siblings:

        curl -v 127.0.0.1:8098/buckets/training/keys/test\?returnbody=true -X PUT -H "content-type: text/plain" -H "x-riak-vclock: [vclock]" -d "resolved"
