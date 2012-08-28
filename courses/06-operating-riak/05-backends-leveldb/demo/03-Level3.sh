#!/bin/bash

val="m1234567890qwertyuiopasdfghjklzxcvbn"
bigval = ""
let i=1
while [ $i -le 56 ]; do
  bigval="${bigval}${val}"
  let i=i+1
done
echo $bigval

let key=4001
echo $key
while [ $key -le 64000 ]; do
  curl -v http://127.0.0.1:8098/buckets/training/keys/big_$key -X PUT -H "content-type: text/plain" -d "$bigval"
  let key=key+1
done

echo -e
