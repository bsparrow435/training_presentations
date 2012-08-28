# Monitoring

## Stats!

Remember Stats? They're useful in monitoring.

## OS Level

### free

`free` is a command that helps you to monitor a physical node's memory usage.

Example output from `free`

```
             total       used       free     shared    buffers     cached
Mem:       3772692    3136556     636136          0     208416    1471592
-/+ buffers/cache:    1456548    2316144
Swap:      1048572      23008    1025564
```

The default output is not optimal for human readability, but there are options `-b`, `-k`, `-m`, `-g`  to show output in bytes, KB, MB, or GB.

### df & du

The `df` command shows you how much space is available on a particular mount point, or all mount points if given no arguments.

The `du` command shows you how much space each file is using. When executed without arguments, `du` will recurse into every subdirectory of the directory provided (or current directory). Use `du -s` to avoid this directory recursion.

### lsof

The `lsof` command will list all open files on the system if given no arguments.

You can use `lsof` in combination with the `wc` command to answer the question: "How many file handles are currently open on this system?":

    lsof | wc -l

## Alerting Tools

### Nagios

If you can get the information you need at the command line, you're pretty close to having a Nagios check.

### collectd

[collectd Homepage](http://collectd.org/)

## Aggregation Tools

Many of these utilities are very good for debugging, spotting trends, and filtering and graphing historical data.

### Graphite

[Graphite](http://graphite.wikidot.com/) - The new hotness in graphing data.

### Splunk

[Splunk](http://www.splunk.com/) Operational Intelligence by monitoring, reporting, and analyzing real-time machine data.

## Community Authored Plugins
[Community Developed Plugins](http://wiki.basho.com/Community-Developed-Libraries-and-Projects.html#Monitoring%2C-Management%2C-and-GUI-Tools)