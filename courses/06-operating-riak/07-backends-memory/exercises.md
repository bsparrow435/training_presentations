# Memory Backend

Stop Riak

Set `storage_backend` in the `riak_kv` section to `riak_kv_memory_backend`

Start Riak

Write an object

        curl -XPUT http://localhost:8098/riak/training/foo \
                -H 'content-type:text/plain' -d 'hello'

Read the object

        curl http://localhost:8098/riak/training/foo

Restart Riak

Read the object

        curl http://localhost:8098/riak/training/foo

* Why did the second read fail?
