# Backup and Restore Reference #
[Backup Wiki Page](http://wiki.basho.com/Backups.html)

Backup strategies depend on which backend you've chosen. Don't think of these as backup and restore strategies in the traditional sense. Riak wasn't build around disaster recovery but around disaster survival. Backup and restore are more useful as tools for swapping out a physical node's hardware without the overhead of rebalancing the ring.

## Bitcask & LevelDB ##
Since Bitcask and LevelDB both use a log structured file format, a copy of the ring and data directories are all you need to restore a failed node.

## Memory ##
You can't backup the memory backend

## Innostore ##
Innostore requires the use of `riak-admin backup` and `riak-admin restore`

## Restore ##
If you are restoring a node with the same -name in vm.args, just restore your data and start riak

If the name is different, `riak-admin reip old-name new-name` needs to be run before starting the node.

In reality, the entire cluster needs to be brought down, and the above reip command needs to be run on each node.

The easiest way to replace a node is to use hostnames from the begining. When you restore a backup data set onto a new node, if that node is configured with the old node's -name, it's easy.