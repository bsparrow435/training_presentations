# Multi Backend

Stop Riak if it is running

Open `etc/app.config`

Locate the `riak_kv` section

Set `storage_backend` to `riak_kv_multi_backend`

Set the following multibackend settings, in the `riak_kv` section:

        {multi_backend_default, <<"leveldb_backend">>},
        {multi_backend, [
                {<<"leveldb_backend">>, riak_kv_eleveldb_backend, []},
                {<<"bitcask_backend">>, riak_kv_bitcask_backend, []}
        ]},

Save the file

Start Riak

Configure the bucket `foo` to use the `leveldb_backend`

        curl -XPUT http://localhost:8098/riak/foo \
                -H 'content-type:application/json' \
                -d '{"props":{"backend":"leveldb_backend"}}'

Configure the bucket `bar` to use the `bitcask_backend`

        curl -XPUT http://localhost:8098/riak/bar \
                -H 'content-type:application/json' \
                -d '{"props":{"backend":"bitcask_backend"}}'

Write an object to the `foo` bucket with secondary indexes

        curl -XPUT http://localhost:8098/riak/foo/dan \
                -H 'content-type:application/json' \
                -H 'x-riak-index-first_name_bin:dan' \
                -d '{"first_name":"dan"}'

Run a 2i query on the `foo` bucket

        curl http://localhost:8098/buckets/foo/index/first_name_bin/dan

Repaet the previous two steps for the `bar` bucket

        curl -XPUT http://localhost:8098/riak/bar/dan \
                -H 'content-type:application/json' \
                -H 'x-riak-index-first_name_bin:dan' \
                -d '{"first_name":"dan"}'

        curl http://localhost:8098/buckets/bar/index/first_name_bin/dan

* Why did the last 2i query fail?
