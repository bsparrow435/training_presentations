#!/bin/bash

let key=1
echo $key
while [ $key -lt 100 ]; do
  curl -v http://127.0.0.1:8098/buckets/training/keys/$key -X PUT -H "content-type: text/plain" -d "My first key"
  let key=key+1
done

echo -e
