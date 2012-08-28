## Exercise ##

It's your job to set up a single node with the following configuration 

```erlang
{riak_core, [
             {ring_creation_size, 4},
...
{riak_kv, [
            {storage_backend, riak_kv_bitcask_backend},
...

{bitcask, [
            {data_root, "./data/bitcask"},
            {max_file_size, 16#80000} % 512kb
          ]},

```

After that, clear out your `data/bitcask` and `data/ring` directories and start riak with `riak console` and from a separate terminal window, run `exercise.sh`. 

`exercise.sh` inserts a few 2048 byte objects and then 512kb of updates to a single object. This brings you over the max_file_size 

After about three minutes you'll see something like this in your riak console output, which means bitcask has triggered a merge.

```
(riak@127.0.0.1)1> 08:07:00.375 [info] Merged "./data/bitcask/0./data/bitcask/0/2.bitcask.data./data/bitcask/0/1.bitcask.data" in 0.025615 seconds.
08:07:00.400 [info] Merged "./data/bitcask/730750818665451459101842416358141509827966271488./data/bitcask/730750818665451459101842416358141509827966271488/2.bitcask.data./data/bitcask/730750818665451459101842416358141509827966271488/1.bitcask.data" in 0.022056 seconds.
08:07:00.422 [info] Merged "./data/bitcask/1096126227998177188652763624537212264741949407232./data/bitcask/1096126227998177188652763624537212264741949407232/2.bitcask.data./data/bitcask/1096126227998177188652763624537212264741949407232/1.bitcask.data" in 0.022282 seconds.
```

**Exercise**: There are a few ways that you can configure bitcask to not merge in this situation. Without changing any of the above configuration values, reconfigure bitcask so it won't merge in this scenario. Empty your `data/bitcask` and `data/ring` directories, start another `riak console` and run `exercise.sh` again to see if it worked. There's no way to make it merge faster than every 3 minutes, so make each configuration count. There's more than one way to do this, try and find as many as you can.