# Memory Backend Reference #
[Basho's Memory Backend Wiki Page](http://wiki.basho.com/Memory.html)

The Memory Backend storage engine uses in-memory tables to store all data. This data is never persisted to disk or any other storage. The Memory storage engine is best used for testing Riak clusters or for small amounts of transient state in production systems.

It uses Erlang's ETS [Erlang Term Storage](http://www.erlang.org/doc/man/ets.html).

## Configuring ##
It comes bundled with Riak.

```erlang
%% Riak KV config
{riak_kv, [
           %% Storage_backend specifies the Erlang module defining the storage
           %% mechanism that will be used on this node.
           {storage_backend, riak_kv_memory_backend},
           %% more kv config follows
},
%% Memory Backend Config
{memory_backend, [
            %% No data_root, it's in memory
            {max_memory, 4096}, %% 4GB in megabytes
            {ttl, 86400}        %% 1 Day in seconds
          ]},
```

**max\_memory**: In megabytes. Don't let a vnode use more than this. Same rules as cache_size for LevelDB

**ttl**: Time in seconds before the object just disappears

