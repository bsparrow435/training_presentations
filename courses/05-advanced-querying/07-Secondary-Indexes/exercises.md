# Secondary Indexes

## Backend

Verify `storage_backend` is set to `riak_kv_eleveldb_backend` in `app.config`

## Groups

Create 10 person objects using the keys and groups below. Set the `group_bin` 
index appropriately for each object.

### Keys

* dan
* joe
* ian
* justin
* tryn
* sowjanya
* brian
* tanya
* casey
* vin

### Groups

* trainer: dan, joe, ian
* da: dan, ian, tryn, sowjanya, brian, tanya, justin
* ps: casey, joe, vin

Lookup all persons in the `trainer` group

Lookup all persons in the `da` group

Lookup all persons in the `ps` group

## MapReduce

Use MapReduce to repeat the above queries and return the object values

## Range Queries

Update each person object with an `age_int` index

Perform several range queries on the `age_int` field

## $key

Lookup persons whose name is in the range `a-j`

Was `justin` in the results?

Repeat the query using the range `a-jv`

Additional Reading:

The [sext](https://github.com/uwiger/sext) library is used to serialize Erlang 
terms while preserving Erlang term order.

## $bucket

List all keys in the person bucket using the `$bucket` index
