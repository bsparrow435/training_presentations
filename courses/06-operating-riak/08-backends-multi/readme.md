# Multi Backend Reference #
[Multi Backend Wiki Page](http://wiki.basho.com/Multi.html)

Riak allows you to run multiple backends within a single Riak instance. This is very useful for two very different use cases; 1. You may want to use different backends for different buckets or 2. You may need to use the same storage engine in different ways for different buckets The Multi backend allows you to configure more than one backend at the same time on a single cluster.

## Configuration ##

```erlang
%% Riak KV config
{riak_kv, [
          ...
          %% Use the Multi Backend
          {storage_backend, riak_kv_multi_backend},
          ...
]}
```

```erlang
%% Use bitcask by default
{riak_kv, [
          ...
          {multi_backend_default, <<"bitcask_mult">>},
          {multi_backend, [
                %% Here's where you set the individual multiplexed backends
                {<<"bitcask_mult">>,  riak_kv_bitcask_backend, [
                                 %% bitcask configuration
                                 {config1, ConfigValue1},
                                 {config2, ConfigValue2}
                ]},
                {<<"eleveldb_mult">>, riak_kv_eleveldb_backend, [
                                 %% eleveldb configuration
                                 {config1, ConfigValue1},
                                 {config2, ConfigValue2}
                ]},
                {<<"second_eleveldb_mult">>,  riak_kv_eleveldb_backend, [
                                 %% eleveldb with a different configuration
                                 {config1, ConfigValue1},
                                 {config2, ConfigValue2}
                ]},
                {<<"memory_mult">>,   riak_kv_memory_backend, [
                                 %% memory configuration
                                 {config1, ConfigValue1},
                                 {config2, ConfigValue2}
                ]}
          ]},
          ...
]},
```
Set the bucket properties to change the backend. ```curl -X PUT -H "Content-Type: application/json" -d '{"props":{"backend":"memory_mult"}}' http://riaknode:8098/riak/transient_example_bucketname```

Once you've changed a bucket's storage engine on a node you'll need to restart the node for that change to take effect.

If you change a bucket's backend with data in it, that data will appear gone at restart, but it's really still
in the old backend. If you change the backend back, you'll see it again, but lose the data in the newer
backend. **Don't change the backend on existing buckets!**

## Gotcha! ##
2i doesn't work with multi\_backend, even if the bucket in question is leveldb
