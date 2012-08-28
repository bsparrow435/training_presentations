# LevelDB Backend Reference

* [Basho's LevelDB Wiki Page](http://wiki.basho.com/LevelDB.html)
* [eLevelDB Source](http://github.com/basho/eleveldb)

## Background

Google designed Key/Value store. It's a set of sorted string tables.

LevelDB per vnode:

Each partition has many levels or sorted string tables within it. Appends to a log, then appends to tables and sorts it as it is writing it out. as you have more and more tables, each level gets a bit bigger. They go through a compaction process, into the next size level.

Very fast, but the problem is that you've got multiple files and you have to do a binary search on each one. It has to read every level to find out if a key exists, which effects not founds and writes.

## How Does It Work?

### Visualization

Imagine one of those Champagne glass pyramids. The top glass is Level-0 and the Champagne is data. As you pour data into the Level-0 glass, it eventually becomes full, and then data starts overflowing into Level-1. The metaphor breaks down a little here, here's how so. In Level-0, the glass represents file count. When it's greater than 4, that's the overflow. When we hit the overflow point, we don't start streaming data down to Level-1. What happens is that everything in the Level-0 glass gets organized and merged with what already exists in the Level-1 glasses. Level-1 has 5 glasses and each Level-1 and greater has glasses that hold 2MB of Champagne. At this point, we're just starting, so Level-1 was empty and every ounce of Champagne in Level-0 had a home in Level-1. Level-0 wanted to write 8MB (4 files x 2MB), and Level-1 had room for 10MB. Now, the empty Level-0 glass starts to fill, and before you know it, we've got another 8MB to write. Level DB takes all the files in Level-0 and all the files in Level-1 and writes out a series of 2MB files, but at 16MB total, we've got 3 too many! Level-1 has started to "overflow" into the empty Level-2.

**Level-0**: Stuff just gets written to files. When there are more than 4 files, they get compacted into Level-1.

**Level-1**: Level-1 should contain 10MB of 2MB files. When Level-0 overflows, all files in Level-0 and Level-1 are compacted together to make a new set of Level-1 files.

**Level-2**: When Level-1 overflows, a file from Level-1 is chosen, along with 10-12 Level-2 files in the corresponding range of the Level-1 file. These are compacted into a new set of Level-2 files and Level-1 has some breathing room. Will try to hit the right file size for that level.

**Level-N**: Use Level-2 process, reading a file from Level-N-1 and 10-12 files from Level-N.

## Why use LevelDB?

### Pros

* Secondary Indexes
* License (New BSD, Apache 2.0)
* More like BigTable's memtable/sstable model than Bitcask or InnoDB
* Does not have Bitcask's RAM limitation or the drawbacks of InnoDB

### Cons

* LevelDB performs a seek per level.
* Key not found is a more expensive operation, because it has to look in each level.


## eLevelDB

The "e" is for Erlang!

## Installing eLevelDB

eLevelDB ships with Riak.

```erlang
%% Riak KV config
{riak_kv, [
           %% Storage_backend specifies the Erlang module defining the storage
           %% mechanism that will be used on this node.
           {storage_backend, riak_kv_eleveldb_backend},
           %% more kv config follows
},
%% LevelDB Config
{eleveldb, [
            {data_root, "/var/lib/riak/leveldb"}
          ]},
```

## Configuring eLevelDB

### write\_buffer\_size

This is the amount of data to build up in memory (backed by an unsorted log on disk) before converting to a sorted on-disk file. Default: 4194304 (4MB).

### max\_open\_files

Number of open files that can be used by the DB. Default: 20 (needs to be at least 20).

### block\_size

Approximate size of user data packed per block. Default: 4096.

### block\_restart\_interval

Number of keys between restart points for delta encoding of keys. Most clients should leave this parameter alone. Default: 16.

### cache\_size ###
The cache\_size determines how much data LevelDB caches in memory. Default: 8388608 (8MB).

### sync

If true, the write will be flushed from the operating system buffer cache before the write is considered complete. Writes will be slower, but data more durable.

If this flag is false, and the machine crashes, some recent writes may be lost. Note that if it is just the process that crashes (i.e., the machine does not reboot), no writes will be lost even if sync is set to false. This is the default setting.

### verify\_checksums

If true, all data read from underlying storage will be verified against corresponding checksums. The default setting is false.

## Tips & Tricks

### Be aware of file handle limits

**max\_open\_files** is the limit of open files per vnode, and has a minimum size of 20. If your node is running 64 vnodes, thats 20 * 64 = 1280 file handles that could be open.

The command `ulimit -n` shows your current open file limit.

Mount volumes with **noatime**.
