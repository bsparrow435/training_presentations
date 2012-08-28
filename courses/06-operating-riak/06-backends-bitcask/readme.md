# Bitcask Backend Reference #
* [Bitcask Wiki Page](http://wiki.basho.com/Bitcask.html)
* [Bitcask Source](http://github.com/basho/bitcask)

## Overview ##
The bitcask backend stores key/value data in a log-structured hash-table. 

### Strengths ###
* Low latency reads and writes
* High throughput
* Datasets larger than RAM without degradation
* Single seek for any value
* Predictable lookup and insert performance
* Fast, bounded crash recovery
* Easy backup

### Weaknesses ###
* Keys must fit in memory

## Installing Bitcask ##
It comes bundled with Riak. Just edit your app.config

```
%% Riak KV config
{riak_kv, [
           %% Storage_backend specifies the Erlang module defining the storage
           %% mechanism that will be used on this node.
           {storage_backend, riak_kv_bitcask_backend},
           %% more kv config follows
},
%% Bitcask Config
{bitcask, [
            {data_root, "/var/lib/riak/bitcask"}
          ]},
```
## Configuring Bitcask ##

**open\_timeout**: Defaults to 4, and shouldn't need changing unless you see ```Failed to start bitcask backend: ...``` in the logs

**sync\_strategy**: When do you write to disk? 

* ```none```: whenever the os wants
* ```o_sync```: uses the O_SYNC flag, and forces syncs on every write (doesn't work on linux, due to a kernel bug)
* ```{seconds, N}```: every N seconds

**max\_file\_size**: Maximum file size before creating a new data file, per partition

**merge\_window**: 

* ```always```: Always, the default
* ```never```: Never
* ```{StartHour, EndHour}```: Integers 0-23. So you can do it off-peak if you have peaks

### Merge Triggers ###
**frag\_merge\_trigger**: (0-100, default 60) percent of keys in a file that are dead to trigger a merge

**dead\_bytes\_merge\_trigger**: bytes that are stored for dead values (default: 536870912, 512MB)
### Merge Thresholds ###
**frag\_threshold**: Same as frag\_trigger, but once a merge is happening, include all files with this percentage of dead keys

**dead\_bytes\_threshold**: Same as the trigger, but include these files in the merge as well

**small\_file\_threshold**: IF you've got files this size or smaller, go ahead and include them too.

## Fold Keys Threshold ##
**max\_fold\_age**:

**max\_fold\_puts**:

## Tips & Tricks ##
Until merge, dead bytes may take up a lot of space. Disk usage is not indicative of working set size.

**Bitcask depends on filesystem caches**: Bitcask depends on the filesystem's cache. Adjusting the caching characteristics of your filesystem can impact performance.

**Be aware of file handle limits**

**Avoid extra disk head seeks by turning off noatime**: You can get a big speed boost by adding the noatime mounting option to /etc/fstab. 

**Small number of frequently changed keys**: Leads to fragmentation, and more frequent merges. To counteract this, one should lower the fragmentation trigger and threshold.

**Limited disk space**: When disk space is limited, keeping the space occupied by dead keys limited is of paramount importance. Lower the dead bytes threshold and trigger to counteract wasted space.

**Purging stale entries after a fixed period**: Set the expiry\_secs value to the desired cutoff time. Keys that are not modified for a period equal to or greater than expiry\_secs will become inaccessible.

**High number of partitions per-node**: Because the cluster has many partitions running, this means Bitcask will have many files open. To reduce the number of open files, you might increase max\_file\_size so that larger files will be written. You might also decrease the fragmentation and dead-bytes settings and increase the small\_file\_threshold so that merging will keep the number of open files small in number.

**High daytime traffic, low nighttime traffic**: In order to cope with a high volume of writes without performance degradation during the day, one might want to prevent merging except in non-peak periods. Setting the merge_window to hours of the day when traffic is low will help.

**Multi-cluster replication (Riak EnterpriseDS)**: Replication could introduce fragmentation. This can be minimized by using full-sync replication.

---
In memory hash table

Each vnode partition gets a directory in the bitcask directory, which contains a data file and a hint file

data files are write once, append only log based hash tables
hint files are full of keys, and offsets into the data files
  bucket/key - offset

bucket/key combo used for size calculations
