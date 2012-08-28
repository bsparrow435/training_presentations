# Bitcask Demo #

## Configuring Bitcask for the demo #

```erlang
{riak_core, [
             {ring_creation_size, 4}, %% Small ring makes for less vnodes
            ]},

{bitcask, [
            {data_root, "./data/bitcask"},
            {max_file_size, 16#80000}     %% 512KB files so we can see growth faster
          ]},
```

You should delete ```data/ring/*``` and ```data/bitcask/*``` so that we're working from a clean install

## The Demo ##
```bin/riak start``` - Start 'er up


```
➜ du -h data/bitcask 
0B	data/bitcask/0
0B	data/bitcask/1096126227998177188652763624537212264741949407232
0B	data/bitcask/365375409332725729550921208179070754913983135744
0B	data/bitcask/730750818665451459101842416358141509827966271488
0B	data/bitcask
```

```
➜ ls -al data/bitcask/0
total 0
drwxr-xr-x  2 joe  staff   68 Feb  3 08:02 .
drwxr-xr-x  6 joe  staff  204 Feb  3 08:02 ..
```

run `01-Init.sh`

```
➜ du -h data/bitcask  
 48K	data/bitcask/0
 48K	data/bitcask/1096126227998177188652763624537212264741949407232
 48K	data/bitcask/365375409332725729550921208179070754913983135744
 52K	data/bitcask/730750818665451459101842416358141509827966271488
196K	data/bitcask
```

```
➜ ls -al data/bitcask/0
total 96
drwxr-xr-x  5 joe  staff    170 Feb  3 08:04 .
drwxr-xr-x  6 joe  staff    204 Feb  3 08:02 ..
-rw-------  1 joe  staff  40318 Feb  3 08:04 1.bitcask.data
-rw-------  1 joe  staff   3109 Feb  3 08:04 1.bitcask.hint
-rw-------  1 joe  staff     38 Feb  3 08:04 bitcask.write.lock
```

We used 512KB files, and only wrote about 40k, so there's only one file.

Run `02-Bigger.sh`

```
➜ du -h data/bitcask
7.6M	data/bitcask/0
7.5M	data/bitcask/1096126227998177188652763624537212264741949407232
7.6M	data/bitcask/365375409332725729550921208179070754913983135744
7.4M	data/bitcask/730750818665451459101842416358141509827966271488
 30M	data/bitcask
```

```
➜ ls -al data/bitcask/0 
total 15544
drwxr-xr-x  33 joe  staff    1122 Feb  3 08:35 .
drwxr-xr-x   6 joe  staff     204 Feb  3 08:02 ..
-rw-------   1 joe  staff  523648 Feb  3 08:34 1.bitcask.data
-rw-------   1 joe  staff   11772 Feb  3 08:34 1.bitcask.hint
-rw-------   1 joe  staff  522071 Feb  3 08:35 10.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 10.bitcask.hint
-rw-------   1 joe  staff  522075 Feb  3 08:35 11.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 11.bitcask.hint
-rw-------   1 joe  staff  522073 Feb  3 08:35 12.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 12.bitcask.hint
-rw-------   1 joe  staff  522071 Feb  3 08:35 13.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 13.bitcask.hint
-rw-------   1 joe  staff  522077 Feb  3 08:35 14.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 14.bitcask.hint
-rw-------   1 joe  staff  432952 Feb  3 08:35 15.bitcask.data
-rw-------   1 joe  staff    7990 Feb  3 08:35 15.bitcask.hint
-rw-------   1 joe  staff  524228 Feb  3 08:34 2.bitcask.data
-rw-------   1 joe  staff    9476 Feb  3 08:34 2.bitcask.hint
-rw-------   1 joe  staff  524222 Feb  3 08:35 3.bitcask.data
-rw-------   1 joe  staff    9476 Feb  3 08:35 3.bitcask.hint
-rw-------   1 joe  staff  521805 Feb  3 08:35 4.bitcask.data
-rw-------   1 joe  staff    9493 Feb  3 08:35 4.bitcask.hint
-rw-------   1 joe  staff  522097 Feb  3 08:35 5.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 5.bitcask.hint
-rw-------   1 joe  staff  522103 Feb  3 08:35 6.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 6.bitcask.hint
-rw-------   1 joe  staff  522079 Feb  3 08:35 7.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 7.bitcask.hint
-rw-------   1 joe  staff  522079 Feb  3 08:35 8.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 8.bitcask.hint
-rw-------   1 joe  staff  522081 Feb  3 08:35 9.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:35 9.bitcask.hint
-rw-------   1 joe  staff      39 Feb  3 08:35 bitcask.write.lock
```

Look at that! 15 files, all in sequence and around 512KB, because there are no dead bytes!

If we run the same script again, this time we'll be writing data that already exists, which should make all of those bytes die, and trigger some merge action.


Oh look, I was checking disk usage periodically during that last run.

```
➜  current  du -h data/bitcask   
8.1M	data/bitcask/0
8.0M	data/bitcask/1096126227998177188652763624537212264741949407232
8.1M	data/bitcask/365375409332725729550921208179070754913983135744
7.9M	data/bitcask/730750818665451459101842416358141509827966271488
 32M	data/bitcask
➜  current  du -h data/bitcask
9.0M	data/bitcask/0
8.9M	data/bitcask/1096126227998177188652763624537212264741949407232
9.0M	data/bitcask/365375409332725729550921208179070754913983135744
8.8M	data/bitcask/730750818665451459101842416358141509827966271488
 36M	data/bitcask
➜  current  du -h data/bitcask
 10M	data/bitcask/0
 10M	data/bitcask/1096126227998177188652763624537212264741949407232
 10M	data/bitcask/365375409332725729550921208179070754913983135744
 10M	data/bitcask/730750818665451459101842416358141509827966271488
 42M	data/bitcask
➜  current  du -h data/bitcask
 12M	data/bitcask/0
 12M	data/bitcask/1096126227998177188652763624537212264741949407232
 12M	data/bitcask/365375409332725729550921208179070754913983135744
 12M	data/bitcask/730750818665451459101842416358141509827966271488
 47M	data/bitcask
➜  current  du -h data/bitcask
 19M	data/bitcask/0
 12M	data/bitcask/1096126227998177188652763624537212264741949407232
 12M	data/bitcask/365375409332725729550921208179070754913983135744
 12M	data/bitcask/730750818665451459101842416358141509827966271488
 55M	data/bitcask
➜  current  du -h data/bitcask
7.7M	data/bitcask/0
 14M	data/bitcask/1096126227998177188652763624537212264741949407232
7.7M	data/bitcask/365375409332725729550921208179070754913983135744
7.4M	data/bitcask/730750818665451459101842416358141509827966271488
 37M	data/bitcask
➜  current  du -h data/bitcask
7.9M	data/bitcask/0
7.6M	data/bitcask/1096126227998177188652763624537212264741949407232
7.9M	data/bitcask/365375409332725729550921208179070754913983135744
7.6M	data/bitcask/730750818665451459101842416358141509827966271488
 31M	data/bitcask
➜  current  du -h data/bitcask
8.2M	data/bitcask/0
7.9M	data/bitcask/1096126227998177188652763624537212264741949407232
8.2M	data/bitcask/365375409332725729550921208179070754913983135744
8.0M	data/bitcask/730750818665451459101842416358141509827966271488
 32M	data/bitcask
➜  current  du -h data/bitcask
9.4M	data/bitcask/0
9.1M	data/bitcask/1096126227998177188652763624537212264741949407232
9.3M	data/bitcask/365375409332725729550921208179070754913983135744
9.1M	data/bitcask/730750818665451459101842416358141509827966271488
 37M	data/bitcask
➜  current  du -h data/bitcask
 11M	data/bitcask/0
 10M	data/bitcask/1096126227998177188652763624537212264741949407232
 10M	data/bitcask/365375409332725729550921208179070754913983135744
 10M	data/bitcask/730750818665451459101842416358141509827966271488
 41M	data/bitcask
```

Let's see what's in our first partition!

```
➜ ls -al data/bitcask/0
total 15552
drwxr-xr-x  35 joe  staff    1190 Feb  3 08:44 .
drwxr-xr-x   6 joe  staff     204 Feb  3 08:02 ..
-rw-------   1 joe  staff  303073 Feb  3 08:41 44.bitcask.data
-rw-------   1 joe  staff    5593 Feb  3 08:41 44.bitcask.hint
-rw-------   1 joe  staff  522081 Feb  3 08:44 45.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 45.bitcask.hint
-rw-------   1 joe  staff  522085 Feb  3 08:44 46.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 46.bitcask.hint
-rw-------   1 joe  staff  522089 Feb  3 08:44 47.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 47.bitcask.hint
-rw-------   1 joe  staff  522093 Feb  3 08:44 48.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 48.bitcask.hint
-rw-------   1 joe  staff  524189 Feb  3 08:44 49.bitcask.data
-rw-------   1 joe  staff    9795 Feb  3 08:44 49.bitcask.hint
-rw-------   1 joe  staff  524101 Feb  3 08:44 50.bitcask.data
-rw-------   1 joe  staff   11658 Feb  3 08:44 50.bitcask.hint
-rw-------   1 joe  staff  524208 Feb  3 08:44 51.bitcask.data
-rw-------   1 joe  staff    9476 Feb  3 08:44 51.bitcask.hint
-rw-------   1 joe  staff  524218 Feb  3 08:44 52.bitcask.data
-rw-------   1 joe  staff    9476 Feb  3 08:44 52.bitcask.hint
-rw-------   1 joe  staff  521795 Feb  3 08:44 53.bitcask.data
-rw-------   1 joe  staff    9494 Feb  3 08:44 53.bitcask.hint
-rw-------   1 joe  staff  522095 Feb  3 08:44 54.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 54.bitcask.hint
-rw-------   1 joe  staff  522089 Feb  3 08:44 55.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 55.bitcask.hint
-rw-------   1 joe  staff  522079 Feb  3 08:44 56.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 56.bitcask.hint
-rw-------   1 joe  staff  522077 Feb  3 08:44 57.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 57.bitcask.hint
-rw-------   1 joe  staff  522075 Feb  3 08:44 58.bitcask.data
-rw-------   1 joe  staff    9635 Feb  3 08:44 58.bitcask.hint
-rw-------   1 joe  staff  127334 Feb  3 08:44 59.bitcask.data
-rw-------   1 joe  staff    2350 Feb  3 08:44 59.bitcask.hint
-rw-------   1 joe  staff      39 Feb  3 08:41 bitcask.write.lock
```

Looks like all those dead byte files are gone