#!/bin/bash

echo '$ curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X DELETE'

curl -v http://127.0.0.1:8098/buckets/capitals/keys/usa -X DELETE

echo -e
