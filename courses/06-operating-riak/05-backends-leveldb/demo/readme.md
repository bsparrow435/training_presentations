# LevelDB Demo #

## Requirements ##
* A single node cluster
* curl
* ```{ring_creation_size, 4}``` and ```{storage_backend, riak_kv_eleveldb_backend}```

Make sure you stop riak, empty the ```data/ring``` and ```data/leveldb``` directories.

When you restart riak, you'll have 4 directories in ```data/leveldb```

```
0
1096126227998177188652763624537212264741949407232
365375409332725729550921208179070754913983135744
730750818665451459101842416358141509827966271488
```

These represent the 4 separate leveldbs running the cluster, one for every partition. The good news is that these values should always be the same.


The following represents an empty leveldb instance. (I chose 1096126227998177188652763624537212264741949407232 instead of the easier to type 0, since it is a busier vnode and we'll have more fun looking at it later. It's entirely based on the bucket key chash distribution).

```ls data/leveldb/1096126227998177188652763624537212264741949407232```

```
-rw-r--r--  1 joe  staff      0 Jan 31 07:44 000003.log
-rw-r--r--  1 joe  staff     16 Jan 31 07:44 CURRENT
-rw-r--r--  1 joe  staff      0 Jan 31 07:44 LOCK
-rw-r--r--  1 joe  staff     53 Jan 31 07:44 LOG
-rw-r--r--  1 joe  staff  65536 Jan 31 07:44 MANIFEST-000002
```

take a ```cat data/leveldb/1096126227998177188652763624537212264741949407232/LOG```. It's nothing exciting, but it will get more exciting from an understanding leveldb point of view

```
2012/01/31-07:44:15.965323 b152b000 Delete type=3 #1
```

run ```./01-Logs.sh``` to insert about 100 small objects. Then check out the directory

```ls data/leveldb/1096126227998177188652763624537212264741949407232```

```
-rw-r--r--  1 joe  staff  65536 Jan 31 07:52 000003.log
-rw-r--r--  1 joe  staff     16 Jan 31 07:44 CURRENT
-rw-r--r--  1 joe  staff      0 Jan 31 07:44 LOCK
-rw-r--r--  1 joe  staff     53 Jan 31 07:44 LOG
-rw-r--r--  1 joe  staff  65536 Jan 31 07:44 MANIFEST-000002
```

It looks pretty similar, but look at how big the .log file has gotten.
The ```LOG``` file is unchanged, because level hasn't done anything but take data in. That's about to change.

run ```./02-Level0.sh``` to insert 4000 2048 byte objects. It'll take about 1 minute

Now, ```ls data/leveldb/1096126227998177188652763624537212264741949407232```

```
-rw-r--r--  1 joe  staff  3080192 Jan 31 08:29 000004.log
-rw-r--r--  1 joe  staff  5191076 Jan 31 08:28 000005.sst
-rw-r--r--  1 joe  staff       16 Jan 31 08:27 CURRENT
-rw-r--r--  1 joe  staff        0 Jan 31 08:27 LOCK
-rw-r--r--  1 joe  staff      239 Jan 31 08:28 LOG
-rw-r--r--  1 joe  staff    65536 Jan 31 08:28 MANIFEST-000002
```

First of all, notice that ```000003.log``` is gone. Once it's read and compacted into Level-0, it's gone. New log messages are writen to new .log files. So what happened? Let's ask the ```LOG``` file


Let's walk through it

```
2012/01/31-07:59:09.109436 b1bbd000 Level-0 table #5: started
2012/01/31-07:59:09.131350 b1bbd000 Level-0 table #5: 4705910 bytes OK
```
Wrote 000003.log into Level-0 table #5 (000005.sst)

```
2012/01/31-07:59:09.147950 b1bbd000 Delete type=0 #3
```
deleted 000003.log

Our log has been written to our first Level-0 table, and we've started a new log. 

The log files are about 5mb, as are the level-0 files, so when level-0 compaction starts, it can't help but also perform level-2 compaction, because 4x5mb > 10mb which is the size of level-1.

Next step, let's add enough data to move into level-3, and see what happens. ```./03-Level3.sh```.

LOG with data in level 3

```
2012/01/31-09:37:54.281996 b1730000 Delete type=3 #1
2012/01/31-09:41:15.306303 b1bbd000 Level-0 table #5: started
2012/01/31-09:41:15.336749 b1bbd000 Level-0 table #5: 3731741 bytes OK
2012/01/31-09:41:15.349277 b1bbd000 Delete type=0 #3
2012/01/31-09:41:40.351504 b1bbd000 Level-0 table #7: started
2012/01/31-09:41:40.381305 b1bbd000 Level-0 table #7: 3731844 bytes OK
2012/01/31-09:41:40.381840 b1bbd000 Delete type=0 #4
2012/01/31-09:42:04.409289 b1bbd000 Level-0 table #9: started
2012/01/31-09:42:04.442576 b1bbd000 Level-0 table #9: 3732023 bytes OK
2012/01/31-09:42:04.454889 b1bbd000 Delete type=0 #6
2012/01/31-09:42:29.181056 b1bbd000 Level-0 table #11: started
2012/01/31-09:42:29.199969 b1bbd000 Level-0 table #11: 3731988 bytes OK
2012/01/31-09:42:29.212469 b1bbd000 Delete type=0 #8
2012/01/31-09:42:29.212605 b1bbd000 Expanding@1 1+1 to 3+1
2012/01/31-09:42:29.212620 b1bbd000 Compacting 3@1 + 1@2 files
2012/01/31-09:42:29.238610 b1bbd000 Generated table #12: 826 keys, 2119716 bytes
2012/01/31-09:42:29.260199 b1bbd000 Generated table #13: 826 keys, 2119730 bytes
2012/01/31-09:42:29.270802 b1bbd000 Generated table #14: 826 keys, 2119703 bytes
2012/01/31-09:42:29.296113 b1bbd000 Generated table #15: 826 keys, 2119752 bytes
2012/01/31-09:42:29.309779 b1bbd000 Generated table #16: 826 keys, 2119759 bytes
2012/01/31-09:42:29.329402 b1bbd000 Generated table #17: 826 keys, 2119752 bytes
2012/01/31-09:42:29.342008 b1bbd000 Generated table #18: 826 keys, 2119125 bytes
2012/01/31-09:42:29.350263 b1bbd000 Generated table #19: 35 keys, 89772 bytes
2012/01/31-09:42:29.350285 b1bbd000 Compacted 3@1 + 1@2 files => 14927309 bytes
2012/01/31-09:42:29.350750 b1bbd000 Delete type=2 #5
2012/01/31-09:42:29.351099 b1bbd000 Delete type=2 #7
2012/01/31-09:42:29.351371 b1bbd000 Delete type=2 #9
2012/01/31-09:42:29.351631 b1bbd000 Delete type=2 #11
2012/01/31-09:42:29.351883 b1bbd000 compacted to: files[ 0 0 8 0 0 0 0 ]
2012/01/31-09:42:53.416523 b1bbd000 Level-0 table #21: started
2012/01/31-09:42:53.435489 b1bbd000 Level-0 table #21: 3731941 bytes OK
2012/01/31-09:42:53.447961 b1bbd000 Delete type=0 #10
2012/01/31-09:43:18.303133 b1bbd000 Level-0 table #23: started
2012/01/31-09:43:18.322442 b1bbd000 Level-0 table #23: 3731748 bytes OK
2012/01/31-09:43:18.334741 b1bbd000 Delete type=0 #20
2012/01/31-09:43:42.866374 b1bbd000 Level-0 table #25: started
2012/01/31-09:43:42.885413 b1bbd000 Level-0 table #25: 3732252 bytes OK
2012/01/31-09:43:42.897801 b1bbd000 Delete type=0 #22
2012/01/31-09:44:07.600573 b1bbd000 Level-0 table #27: started
2012/01/31-09:44:07.619892 b1bbd000 Level-0 table #27: 3732298 bytes OK
2012/01/31-09:44:07.632123 b1bbd000 Delete type=0 #24
2012/01/31-09:44:32.965229 b1bbd000 Level-0 table #29: started
2012/01/31-09:44:32.984249 b1bbd000 Level-0 table #29: 3732275 bytes OK
2012/01/31-09:44:32.996547 b1bbd000 Delete type=0 #26
2012/01/31-09:44:32.996683 b1bbd000 Compacting 1@1 + 2@2 files
2012/01/31-09:44:33.018212 b1bbd000 Generated table #30: 826 keys, 2119730 bytes
2012/01/31-09:44:33.036296 b1bbd000 Generated table #31: 826 keys, 2119711 bytes
2012/01/31-09:44:33.056193 b1bbd000 Generated table #32: 663 keys, 1701384 bytes
2012/01/31-09:44:33.056218 b1bbd000 Compacted 1@1 + 2@2 files => 5940825 bytes
2012/01/31-09:44:33.060114 b1bbd000 Delete type=2 #18
2012/01/31-09:44:33.060404 b1bbd000 Delete type=2 #19
2012/01/31-09:44:33.060479 b1bbd000 Delete type=2 #21
2012/01/31-09:44:33.060809 b1bbd000 compacted to: files[ 2 2 9 0 0 0 0 ]
2012/01/31-09:44:57.471578 b1bbd000 Level-0 table #34: started
2012/01/31-09:44:57.490728 b1bbd000 Level-0 table #34: 3732270 bytes OK
2012/01/31-09:44:57.503233 b1bbd000 Delete type=0 #28
2012/01/31-09:44:57.503367 b1bbd000 Expanding@1 1+1 to 3+1
2012/01/31-09:44:57.503382 b1bbd000 Compacting 3@1 + 1@2 files
2012/01/31-09:44:57.518148 b1bbd000 Generated table #35: 826 keys, 2120703 bytes
2012/01/31-09:44:57.533464 b1bbd000 Generated table #36: 826 keys, 2121332 bytes
2012/01/31-09:44:57.551846 b1bbd000 Generated table #37: 826 keys, 2121340 bytes
2012/01/31-09:44:57.567559 b1bbd000 Generated table #38: 826 keys, 2121280 bytes
2012/01/31-09:44:57.586780 b1bbd000 Generated table #39: 826 keys, 2121277 bytes
2012/01/31-09:44:57.604607 b1bbd000 Generated table #40: 826 keys, 2121336 bytes
2012/01/31-09:44:57.613256 b1bbd000 Generated table #41: 229 keys, 588026 bytes
2012/01/31-09:44:57.613283 b1bbd000 Compacted 3@1 + 1@2 files => 13315294 bytes
2012/01/31-09:44:57.615181 b1bbd000 Delete type=2 #12
2012/01/31-09:44:57.615712 b1bbd000 Delete type=2 #27
2012/01/31-09:44:57.616083 b1bbd000 Delete type=2 #29
2012/01/31-09:44:57.616444 b1bbd000 Delete type=2 #34
2012/01/31-09:44:57.616790 b1bbd000 compacted to: files[ 2 0 15 0 0 0 0 ]
2012/01/31-09:45:22.170115 b1bbd000 Level-0 table #43: started
2012/01/31-09:45:22.189164 b1bbd000 Level-0 table #43: 3732296 bytes OK
2012/01/31-09:45:22.201465 b1bbd000 Delete type=0 #33
2012/01/31-09:45:47.056054 b1bbd000 Level-0 table #45: started
2012/01/31-09:45:47.081461 b1bbd000 Level-0 table #45: 3732246 bytes OK
2012/01/31-09:45:47.094099 b1bbd000 Delete type=0 #42
2012/01/31-09:46:11.514299 b1bbd000 Level-0 table #47: started
2012/01/31-09:46:11.533256 b1bbd000 Level-0 table #47: 3732287 bytes OK
2012/01/31-09:46:11.545717 b1bbd000 Delete type=0 #44
2012/01/31-09:46:11.545853 b1bbd000 Expanding@1 1+2 to 3+2
2012/01/31-09:46:11.545869 b1bbd000 Compacting 3@1 + 2@2 files
2012/01/31-09:46:11.563254 b1bbd000 Generated table #48: 826 keys, 2121306 bytes
2012/01/31-09:46:11.580212 b1bbd000 Generated table #49: 826 keys, 2121322 bytes
2012/01/31-09:46:11.603103 b1bbd000 Generated table #50: 826 keys, 2121276 bytes
2012/01/31-09:46:11.624192 b1bbd000 Generated table #51: 826 keys, 2121313 bytes
2012/01/31-09:46:11.650308 b1bbd000 Generated table #52: 826 keys, 2121290 bytes
2012/01/31-09:46:11.659110 b1bbd000 Generated table #53: 826 keys, 2121296 bytes
2012/01/31-09:46:11.692940 b1bbd000 Generated table #54: 458 keys, 1175423 bytes
2012/01/31-09:46:11.692960 b1bbd000 Compacted 3@1 + 2@2 files => 13903226 bytes
2012/01/31-09:46:11.696840 b1bbd000 Delete type=2 #13
2012/01/31-09:46:11.697076 b1bbd000 Delete type=2 #41
2012/01/31-09:46:11.697165 b1bbd000 Delete type=2 #43
2012/01/31-09:46:11.697422 b1bbd000 Delete type=2 #45
2012/01/31-09:46:11.697683 b1bbd000 Delete type=2 #47
2012/01/31-09:46:11.697948 b1bbd000 compacted to: files[ 2 0 20 0 0 0 0 ]
2012/01/31-09:46:36.445515 b1bbd000 Level-0 table #56: started
2012/01/31-09:46:36.464438 b1bbd000 Level-0 table #56: 3732267 bytes OK
2012/01/31-09:46:36.477078 b1bbd000 Delete type=0 #46
2012/01/31-09:47:01.795684 b1bbd000 Level-0 table #58: started
2012/01/31-09:47:01.814653 b1bbd000 Level-0 table #58: 3732238 bytes OK
2012/01/31-09:47:01.827010 b1bbd000 Delete type=0 #55
2012/01/31-09:47:26.527300 b1bbd000 Level-0 table #60: started
2012/01/31-09:47:26.546399 b1bbd000 Level-0 table #60: 3732265 bytes OK
2012/01/31-09:47:26.558861 b1bbd000 Delete type=0 #57
2012/01/31-09:47:26.558997 b1bbd000 Compacting 1@1 + 1@2 files
2012/01/31-09:47:26.577272 b1bbd000 Generated table #61: 826 keys, 2121291 bytes
2012/01/31-09:47:26.594886 b1bbd000 Generated table #62: 826 keys, 2121276 bytes
2012/01/31-09:47:26.603738 b1bbd000 Generated table #63: 259 keys, 664738 bytes
2012/01/31-09:47:26.603756 b1bbd000 Compacted 1@1 + 1@2 files => 4907305 bytes
2012/01/31-09:47:26.605717 b1bbd000 Delete type=2 #54
2012/01/31-09:47:26.605944 b1bbd000 Delete type=2 #56
2012/01/31-09:47:26.606296 b1bbd000 compacted to: files[ 2 2 22 0 0 0 0 ]
2012/01/31-09:47:50.957400 b1bbd000 Level-0 table #65: started
2012/01/31-09:47:50.976209 b1bbd000 Level-0 table #65: 3732194 bytes OK
2012/01/31-09:47:50.988822 b1bbd000 Delete type=0 #59
2012/01/31-09:47:50.988971 b1bbd000 Compacting 1@1 + 1@2 files
2012/01/31-09:47:51.010624 b1bbd000 Generated table #66: 826 keys, 2121330 bytes
2012/01/31-09:47:51.027299 b1bbd000 Generated table #67: 826 keys, 2121214 bytes
2012/01/31-09:47:51.035800 b1bbd000 Generated table #68: 60 keys, 153993 bytes
2012/01/31-09:47:51.035822 b1bbd000 Compacted 1@1 + 1@2 files => 4396537 bytes
2012/01/31-09:47:51.036202 b1bbd000 Delete type=2 #58
2012/01/31-09:47:51.036553 b1bbd000 Delete type=2 #63
2012/01/31-09:47:51.036665 b1bbd000 compacted to: files[ 2 2 24 0 0 0 0 ]
2012/01/31-09:48:16.270807 b1bbd000 Level-0 table #70: started
2012/01/31-09:48:16.289900 b1bbd000 Level-0 table #70: 3732222 bytes OK
2012/01/31-09:48:16.302577 b1bbd000 Delete type=0 #64
2012/01/31-09:48:16.302717 b1bbd000 Expanding@1 1+3 to 3+3
2012/01/31-09:48:16.302734 b1bbd000 Compacting 3@1 + 3@2 files
2012/01/31-09:48:16.318794 b1bbd000 Generated table #71: 826 keys, 2121269 bytes
2012/01/31-09:48:16.346553 b1bbd000 Generated table #72: 826 keys, 2121323 bytes
2012/01/31-09:48:16.355737 b1bbd000 Generated table #73: 826 keys, 2121322 bytes
2012/01/31-09:48:16.384671 b1bbd000 Generated table #74: 826 keys, 2121263 bytes
2012/01/31-09:48:16.398606 b1bbd000 Generated table #75: 826 keys, 2121296 bytes
2012/01/31-09:48:16.419129 b1bbd000 Generated table #76: 826 keys, 2121286 bytes
2012/01/31-09:48:16.431736 b1bbd000 Generated table #77: 826 keys, 2120944 bytes
2012/01/31-09:48:16.440935 b1bbd000 Generated table #78: 289 keys, 741711 bytes
2012/01/31-09:48:16.440956 b1bbd000 Compacted 3@1 + 3@2 files => 15590414 bytes
2012/01/31-09:48:16.442930 b1bbd000 Delete type=2 #14
2012/01/31-09:48:16.443156 b1bbd000 Delete type=2 #60
2012/01/31-09:48:16.443425 b1bbd000 Delete type=2 #65
2012/01/31-09:48:16.443684 b1bbd000 Delete type=2 #67
2012/01/31-09:48:16.443837 b1bbd000 Delete type=2 #68
2012/01/31-09:48:16.443900 b1bbd000 Delete type=2 #70
2012/01/31-09:48:16.444161 b1bbd000 compacted to: files[ 2 0 29 0 0 0 0 ]
2012/01/31-09:48:40.992034 b1bbd000 Level-0 table #80: started
2012/01/31-09:48:41.011024 b1bbd000 Level-0 table #80: 3732257 bytes OK
2012/01/31-09:48:41.023499 b1bbd000 Delete type=0 #69
2012/01/31-09:49:05.652848 b1bbd000 Level-0 table #82: started
2012/01/31-09:49:05.671870 b1bbd000 Level-0 table #82: 3732281 bytes OK
2012/01/31-09:49:05.684435 b1bbd000 Delete type=0 #79
2012/01/31-09:49:30.264672 b1bbd000 Level-0 table #84: started
2012/01/31-09:49:30.289549 b1bbd000 Level-0 table #84: 3732305 bytes OK
2012/01/31-09:49:30.302281 b1bbd000 Delete type=0 #81
2012/01/31-09:49:30.302418 b1bbd000 Compacting 1@1 + 1@2 files
2012/01/31-09:49:30.318857 b1bbd000 Generated table #85: 826 keys, 2121257 bytes
2012/01/31-09:49:30.337668 b1bbd000 Generated table #86: 826 keys, 2121297 bytes
2012/01/31-09:49:30.348402 b1bbd000 Generated table #87: 627 keys, 1610279 bytes
2012/01/31-09:49:30.348422 b1bbd000 Compacted 1@1 + 1@2 files => 5852833 bytes
2012/01/31-09:49:30.352420 b1bbd000 Delete type=2 #77
2012/01/31-09:49:30.352658 b1bbd000 Delete type=2 #80
2012/01/31-09:49:30.352948 b1bbd000 compacted to: files[ 2 2 31 0 0 0 0 ]
2012/01/31-09:49:55.388079 b1bbd000 Level-0 table #89: started
2012/01/31-09:49:55.407206 b1bbd000 Level-0 table #89: 3732310 bytes OK
2012/01/31-09:49:55.419748 b1bbd000 Delete type=0 #83
2012/01/31-09:49:55.419890 b1bbd000 Compacting 1@1 + 1@2 files
2012/01/31-09:49:55.439939 b1bbd000 Generated table #90: 826 keys, 2121318 bytes
2012/01/31-09:49:55.449682 b1bbd000 Generated table #91: 826 keys, 2121213 bytes
2012/01/31-09:49:55.457958 b1bbd000 Generated table #92: 90 keys, 230981 bytes
2012/01/31-09:49:55.457979 b1bbd000 Compacted 1@1 + 1@2 files => 4473512 bytes
2012/01/31-09:49:55.458932 b1bbd000 Delete type=2 #78
2012/01/31-09:49:55.459087 b1bbd000 Delete type=2 #82
2012/01/31-09:49:55.459376 b1bbd000 compacted to: files[ 2 2 33 0 0 0 0 ]
2012/01/31-09:50:20.204390 b1bbd000 Level-0 table #94: started
2012/01/31-09:50:20.222728 b1bbd000 Level-0 table #94: 3732193 bytes OK
2012/01/31-09:50:20.235074 b1bbd000 Delete type=0 #88
2012/01/31-09:50:20.235222 b1bbd000 Expanding@1 1+3 to 3+3
2012/01/31-09:50:20.235238 b1bbd000 Compacting 3@1 + 3@2 files
2012/01/31-09:50:20.249261 b1bbd000 Generated table #95: 826 keys, 2121278 bytes
2012/01/31-09:50:20.283271 b1bbd000 Generated table #96: 826 keys, 2121266 bytes
2012/01/31-09:50:20.293142 b1bbd000 Generated table #97: 826 keys, 2121293 bytes
2012/01/31-09:50:20.320700 b1bbd000 Generated table #98: 826 keys, 2121329 bytes
2012/01/31-09:50:20.335667 b1bbd000 Generated table #99: 826 keys, 2121312 bytes
2012/01/31-09:50:20.354717 b1bbd000 Generated table #100: 826 keys, 2121269 bytes
2012/01/31-09:50:20.374835 b1bbd000 Generated table #101: 826 keys, 2121001 bytes
2012/01/31-09:50:20.384326 b1bbd000 Generated table #102: 319 keys, 818734 bytes
2012/01/31-09:50:20.384347 b1bbd000 Compacted 3@1 + 3@2 files => 15667482 bytes
2012/01/31-09:50:20.386247 b1bbd000 Delete type=2 #15
2012/01/31-09:50:20.392821 b1bbd000 Delete type=2 #84
2012/01/31-09:50:20.393156 b1bbd000 Delete type=2 #89
2012/01/31-09:50:20.393434 b1bbd000 Delete type=2 #91
2012/01/31-09:50:20.393600 b1bbd000 Delete type=2 #92
2012/01/31-09:50:20.393663 b1bbd000 Delete type=2 #94
2012/01/31-09:50:20.393936 b1bbd000 compacted to: files[ 2 0 38 0 0 0 0 ]
2012/01/31-09:50:45.617630 b1bbd000 Level-0 table #104: started
2012/01/31-09:50:45.647754 b1bbd000 Level-0 table #104: 3732323 bytes OK
2012/01/31-09:50:45.660129 b1bbd000 Delete type=0 #93
2012/01/31-09:51:11.276868 b1bbd000 Level-0 table #106: started
2012/01/31-09:51:11.608902 b1bbd000 Level-0 table #106: 3732248 bytes OK
2012/01/31-09:51:11.609498 b1bbd000 Delete type=0 #103
2012/01/31-09:51:36.395345 b1bbd000 Level-0 table #108: started
2012/01/31-09:51:36.414522 b1bbd000 Level-0 table #108: 3732283 bytes OK
2012/01/31-09:51:36.426786 b1bbd000 Delete type=0 #105
2012/01/31-09:51:36.426933 b1bbd000 Compacting 1@1 + 2@2 files
2012/01/31-09:51:36.444518 b1bbd000 Generated table #109: 826 keys, 2121255 bytes
2012/01/31-09:51:36.465051 b1bbd000 Generated table #110: 826 keys, 2121278 bytes
2012/01/31-09:51:36.473828 b1bbd000 Generated table #111: 826 keys, 2121014 bytes
2012/01/31-09:51:36.482489 b1bbd000 Generated table #112: 120 keys, 307985 bytes
2012/01/31-09:51:36.482511 b1bbd000 Compacted 1@1 + 2@2 files => 6671532 bytes
2012/01/31-09:51:36.483439 b1bbd000 Delete type=2 #101
2012/01/31-09:51:36.483696 b1bbd000 Delete type=2 #102
2012/01/31-09:51:36.483837 b1bbd000 Delete type=2 #104
2012/01/31-09:51:36.484138 b1bbd000 compacted to: files[ 2 2 40 0 0 0 0 ]
2012/01/31-10:05:54.470082 b1bbd000 Level-0 table #114: started
2012/01/31-10:05:54.502266 b1bbd000 Level-0 table #114: 3732259 bytes OK
2012/01/31-10:05:54.515486 b1bbd000 Delete type=0 #107
2012/01/31-10:05:54.516171 b1bbd000 Compacting 1@1 + 2@2 files
2012/01/31-10:05:54.550784 b1bbd000 Generated table #115: 826 keys, 2121329 bytes
2012/01/31-10:05:54.572337 b1bbd000 Generated table #116: 826 keys, 2121257 bytes
2012/01/31-10:05:54.588045 b1bbd000 Generated table #117: 747 keys, 1918225 bytes
2012/01/31-10:05:54.588073 b1bbd000 Compacted 1@1 + 2@2 files => 6160811 bytes
2012/01/31-10:05:54.591999 b1bbd000 Delete type=2 #106
2012/01/31-10:05:54.593813 b1bbd000 Delete type=2 #111
2012/01/31-10:05:54.594924 b1bbd000 Delete type=2 #112
2012/01/31-10:05:54.596364 b1bbd000 compacted to: files[ 2 2 41 0 0 0 0 ]
2012/01/31-10:06:19.247147 b1bbd000 Level-0 table #119: started
2012/01/31-10:06:19.276522 b1bbd000 Level-0 table #119: 3732301 bytes OK
2012/01/31-10:06:19.288866 b1bbd000 Delete type=0 #113
2012/01/31-10:06:19.289010 b1bbd000 Expanding@1 1+2 to 3+2
2012/01/31-10:06:19.289025 b1bbd000 Compacting 3@1 + 2@2 files
2012/01/31-10:06:19.305956 b1bbd000 Generated table #120: 826 keys, 2121257 bytes
2012/01/31-10:06:19.329023 b1bbd000 Generated table #121: 826 keys, 2121315 bytes
2012/01/31-10:06:19.345206 b1bbd000 Generated table #122: 826 keys, 2121276 bytes
2012/01/31-10:06:19.369916 b1bbd000 Generated table #123: 826 keys, 2121314 bytes
2012/01/31-10:06:19.396845 b1bbd000 Generated table #124: 826 keys, 2121275 bytes
2012/01/31-10:06:19.420759 b1bbd000 Generated table #125: 826 keys, 2121322 bytes
2012/01/31-10:06:19.434880 b1bbd000 Generated table #126: 826 keys, 2120748 bytes
2012/01/31-10:06:19.448958 b1bbd000 Generated table #127: 150 keys, 384980 bytes
2012/01/31-10:06:19.448989 b1bbd000 Compacted 3@1 + 2@2 files => 15233487 bytes
2012/01/31-10:06:19.453537 b1bbd000 Delete type=2 #16
2012/01/31-10:06:19.455340 b1bbd000 Delete type=2 #108
2012/01/31-10:06:19.456832 b1bbd000 Delete type=2 #114
2012/01/31-10:06:19.457374 b1bbd000 Delete type=2 #117
2012/01/31-10:06:19.457676 b1bbd000 Delete type=2 #119
2012/01/31-10:06:19.457968 b1bbd000 compacted to: files[ 2 0 47 0 0 0 0 ]
2012/01/31-10:06:45.539541 b1bbd000 Level-0 table #129: started
2012/01/31-10:06:45.568412 b1bbd000 Level-0 table #129: 3732208 bytes OK
2012/01/31-10:06:45.580964 b1bbd000 Delete type=0 #118
2012/01/31-10:07:11.010365 b1bbd000 Level-0 table #131: started
2012/01/31-10:07:11.028203 b1bbd000 Level-0 table #131: 3732276 bytes OK
2012/01/31-10:07:11.040863 b1bbd000 Delete type=0 #128
2012/01/31-10:07:36.049457 b1bbd000 Level-0 table #133: started
2012/01/31-10:07:36.067459 b1bbd000 Level-0 table #133: 3732210 bytes OK
2012/01/31-10:07:36.079770 b1bbd000 Delete type=0 #130
2012/01/31-10:07:36.079919 b1bbd000 Compacting 1@1 + 1@2 files
2012/01/31-10:07:36.089236 b1bbd000 Generated table #134: 826 keys, 2121275 bytes
2012/01/31-10:07:36.100261 b1bbd000 Generated table #135: 826 keys, 2121250 bytes
2012/01/31-10:07:36.110934 b1bbd000 Generated table #136: 627 keys, 1610091 bytes
2012/01/31-10:07:36.110962 b1bbd000 Compacted 1@1 + 1@2 files => 5852616 bytes
2012/01/31-10:07:36.114852 b1bbd000 Delete type=2 #126
2012/01/31-10:07:36.115095 b1bbd000 Delete type=2 #129
2012/01/31-10:07:36.115389 b1bbd000 compacted to: files[ 2 2 49 0 0 0 0 ]
2012/01/31-10:08:02.024247 b1bbd000 Level-0 table #138: started
2012/01/31-10:08:02.042454 b1bbd000 Level-0 table #138: 3732291 bytes OK
2012/01/31-10:08:02.055089 b1bbd000 Delete type=0 #132
2012/01/31-10:08:02.055287 b1bbd000 Compacting 1@1 + 2@2 files
2012/01/31-10:08:02.069452 b1bbd000 Generated table #139: 826 keys, 2121309 bytes
2012/01/31-10:08:02.080722 b1bbd000 Generated table #140: 826 keys, 2121321 bytes
2012/01/31-10:08:02.098095 b1bbd000 Generated table #141: 578 keys, 1484260 bytes
2012/01/31-10:08:02.098120 b1bbd000 Compacted 1@1 + 2@2 files => 5726890 bytes
2012/01/31-10:08:02.102116 b1bbd000 Delete type=2 #127
2012/01/31-10:08:02.102281 b1bbd000 Delete type=2 #131
2012/01/31-10:08:02.102630 b1bbd000 Delete type=2 #136
2012/01/31-10:08:02.102859 b1bbd000 compacted to: files[ 2 2 50 0 0 0 0 ]
2012/01/31-10:08:27.325337 b1bbd000 Level-0 table #143: started
2012/01/31-10:08:27.353878 b1bbd000 Level-0 table #143: 3732313 bytes OK
2012/01/31-10:08:27.366162 b1bbd000 Delete type=0 #137
2012/01/31-10:08:27.366306 b1bbd000 Expanding@1 1+2 to 3+2
2012/01/31-10:08:27.366321 b1bbd000 Compacting 3@1 + 2@2 files
2012/01/31-10:08:27.384709 b1bbd000 Generated table #144: 826 keys, 2121314 bytes
2012/01/31-10:08:27.398410 b1bbd000 Generated table #145: 826 keys, 2121300 bytes
2012/01/31-10:08:27.416654 b1bbd000 Generated table #146: 826 keys, 2121293 bytes
2012/01/31-10:08:27.430586 b1bbd000 Generated table #147: 826 keys, 2121321 bytes
2012/01/31-10:08:27.448311 b1bbd000 Generated table #148: 826 keys, 2121304 bytes
2012/01/31-10:08:27.464290 b1bbd000 Generated table #149: 826 keys, 2121312 bytes
2012/01/31-10:08:27.473171 b1bbd000 Generated table #150: 807 keys, 2071646 bytes
2012/01/31-10:08:27.473189 b1bbd000 Compacted 3@1 + 2@2 files => 14799490 bytes
2012/01/31-10:08:27.481258 b1bbd000 Delete type=2 #17
2012/01/31-10:08:27.482856 b1bbd000 Delete type=2 #133
2012/01/31-10:08:27.483280 b1bbd000 Delete type=2 #138
2012/01/31-10:08:27.483657 b1bbd000 Delete type=2 #141
2012/01/31-10:08:27.483863 b1bbd000 Delete type=2 #143
2012/01/31-10:08:27.484229 b1bbd000 compacted to: files[ 2 0 55 0 0 0 0 ]
2012/01/31-10:08:27.484639 b1bbd000 Moved #35 to level-3 2120703 bytes OK: files[ 2 0 54 1 0 0 0 ]
2012/01/31-10:08:27.484765 b1bbd000 Moved #36 to level-3 2121332 bytes OK: files[ 2 0 53 2 0 0 0 ]
2012/01/31-10:08:27.484882 b1bbd000 Moved #37 to level-3 2121340 bytes OK: files[ 2 0 52 3 0 0 0 ]
2012/01/31-10:08:27.485003 b1bbd000 Moved #38 to level-3 2121280 bytes OK: files[ 2 0 51 4 0 0 0 ]
2012/01/31-10:08:27.485142 b1bbd000 Moved #39 to level-3 2121277 bytes OK: files[ 2 0 50 5 0 0 0 ]
2012/01/31-10:08:27.485281 b1bbd000 Moved #40 to level-3 2121336 bytes OK: files[ 2 0 49 6 0 0 0 ] <-- Final Level Counts
```

```
➜  data  du -h leveldb
118M	leveldb/0
118M	leveldb/1096126227998177188652763624537212264741949407232
119M	leveldb/365375409332725729550921208179070754913983135744
117M	leveldb/730750818665451459101842416358141509827966271488
473M	leveldb
```

```
➜  data  ls leveldb/1096126227998177188652763624537212264741949407232 
total 241680
drwxr-xr-x  64 joe  staff     2176 Jan 31 10:08 .
drwxr-xr-x   7 joe  staff      238 Jan 31 09:37 ..
-rw-r--r--   1 joe  staff  3731748 Jan 31 09:43 000023.sst    <-- Level-0  >2MB
-rw-r--r--   1 joe  staff  3732252 Jan 31 09:43 000025.sst    <-- Level-0  >2MB
-rw-r--r--   1 joe  staff  2119730 Jan 31 09:44 000030.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2119711 Jan 31 09:44 000031.sst    <--     Level-2
-rw-r--r--   1 joe  staff  1701384 Jan 31 09:44 000032.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2120703 Jan 31 09:44 000035.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121332 Jan 31 09:44 000036.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121340 Jan 31 09:44 000037.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121280 Jan 31 09:44 000038.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121277 Jan 31 09:44 000039.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121336 Jan 31 09:44 000040.sst    <--       Level-3
-rw-r--r--   1 joe  staff  2121306 Jan 31 09:46 000048.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121322 Jan 31 09:46 000049.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121276 Jan 31 09:46 000050.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121313 Jan 31 09:46 000051.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121290 Jan 31 09:46 000052.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121296 Jan 31 09:46 000053.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121291 Jan 31 09:47 000061.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121276 Jan 31 09:47 000062.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121330 Jan 31 09:47 000066.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121269 Jan 31 09:48 000071.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121323 Jan 31 09:48 000072.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121322 Jan 31 09:48 000073.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121263 Jan 31 09:48 000074.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121296 Jan 31 09:48 000075.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121286 Jan 31 09:48 000076.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121257 Jan 31 09:49 000085.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121297 Jan 31 09:49 000086.sst    <--     Level-2
-rw-r--r--   1 joe  staff  1610279 Jan 31 09:49 000087.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121318 Jan 31 09:49 000090.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121278 Jan 31 09:50 000095.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121266 Jan 31 09:50 000096.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121293 Jan 31 09:50 000097.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121329 Jan 31 09:50 000098.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121312 Jan 31 09:50 000099.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121269 Jan 31 09:50 000100.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121255 Jan 31 09:51 000109.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121278 Jan 31 09:51 000110.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121329 Jan 31 10:05 000115.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121257 Jan 31 10:05 000116.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121257 Jan 31 10:06 000120.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121315 Jan 31 10:06 000121.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121276 Jan 31 10:06 000122.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121314 Jan 31 10:06 000123.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121275 Jan 31 10:06 000124.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121322 Jan 31 10:06 000125.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121275 Jan 31 10:07 000134.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121250 Jan 31 10:07 000135.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121309 Jan 31 10:08 000139.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121321 Jan 31 10:08 000140.sst    <--     Level-2
-rw-r--r--   1 joe  staff   458752 Jan 31 10:08 000142.log    <-- log
-rw-r--r--   1 joe  staff  2121314 Jan 31 10:08 000144.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121300 Jan 31 10:08 000145.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121293 Jan 31 10:08 000146.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121321 Jan 31 10:08 000147.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121304 Jan 31 10:08 000148.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2121312 Jan 31 10:08 000149.sst    <--     Level-2
-rw-r--r--   1 joe  staff  2071646 Jan 31 10:08 000150.sst    <--     Level-2
-rw-r--r--   1 joe  staff       16 Jan 31 09:37 CURRENT
-rw-r--r--   1 joe  staff        0 Jan 31 09:37 LOCK
-rw-r--r--   1 joe  staff    20450 Jan 31 10:08 LOG
-rw-r--r--   1 joe  staff    65536 Jan 31 10:08 MANIFEST-000002
```