#!/bin/bash

echo '$ curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X PUT -H "content-type: text/plain" -d "Washington D.C."'

curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X PUT -H "content-type: text/plain" -d "Washington D.C."

echo -e
