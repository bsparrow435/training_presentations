#!/bin/bash

val="m1234567890qwertyuiopasdfghjklzx"
bigval="12"
let i=1
while [ $i -le 53 ]; do
  bigval="${bigval}${val}"
  let i=i+1
done
#echo $bigval

let key=0
echo $key
while [ $key -le 25 ]; do
  curl -v http://127.0.0.1:8098/buckets/training/keys/over_and_over$key -X PUT -H "content-type: text/plain" -d "$bigval"
  let key=key+1
done



let key=0
echo $key
while [ $key -le 255 ]; do
  curl -v http://127.0.0.1:8098/buckets/training/keys/over_and_over -X PUT -H "content-type: text/plain" -d "$bigval"
  let key=key+1
done

echo -e
