# Search - KV Integration

## Activate Search

Activate search on the `kv1` bucket from the command line:

        ./bin/search-cmd install kv1

Activate search on the `kv2` bucket through the HTTP API:

        curl -i -XPUT http://localhost:8098/riak/kv2 \
        -H 'content-type:application/json' \
        -d '{"props":{"search":true}}'

## text/plain

Store several `text/plain` objects in the `kv1` bucket:

        curl -i -XPUT http://localhost:8098/riak/kv1/foo.txt -d "demo data goes here"
        curl -i -XPUT http://localhost:8098/riak/kv1/bar.txt -d "demo demo demo demo"
        curl -i -XPUT http://localhost:8098/riak/kv1/baz.txt -d "nothing to see here"
        curl -i -XPUT http://localhost:8098/riak/kv1/qux.txt -d "demo demo"

Write a MapReduce query using a search input to find all documents with the word
`demo`.

## application/json

Store the following `application/json` object in the `kv2` bucket with the key 
`1`:

        {"pangram":true,
         "phrase":"The quick brown fox jumps over the lazy dog"}

Write a MapReduce query using a search input for the following queries:

        phrase:quick
        phrase:dog
        phrase:"quick dog"
        phrase:bro*
        phrase:[dig TO dug]
        phrase:"quick dog"~8
