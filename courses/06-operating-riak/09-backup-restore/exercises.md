# Backup and Restore

The following backup/restore techniques are for restoring a node that might be 
lost (e.g. an Amazon EC2 instance that disappears). These methods would NOT be 
appropriate for migrating data between nodes.

## Setup

Start Riak

Write an object to Riak

        curl -XPUT http://localhost:8098/riak/bar/dan \
                -H 'content-type:application/json' \
                -d '{"first_name":"dan"}'

## Method 1

Backup the node to disk

        riak-admin backup riak@127.0.0.1 riak backup1 node

* The above command assumes the node name is `riak@127.0.0.1` and the cookie is
`riak`

Generate a new node

        generate-node.sh path/to/bin/riak restore1

Start the `restore1@127.0.0.1` node

        restore1/bin/riak start

Restore data from the `backup1` file

        restore1/bin/riak-admin restore restore1@127.0.0.1 riak /full/path/to/backup1-riak@127.0.0.1

* The above command assumes the node name is `riak@127.0.0.1` and the cookie is
`riak`

Grep for the HTTP port for `restore1@127.0.0.1`

        grep http restore1/etc/app.config

Read the object using that HTTP port

        curl http://localhost:HTTP_PORT/riak/bar/dan
        

## Method 2

* This method assumes the `riak@127.0.0.1` node is using the Bitcask backend.

Backup the data using tar

        tar czf backup2.tar.gz data/bitcask data/ring

Generate a new node

        generate-node.sh path/to/bin/riak restore2

Untar `backup2.tar.gz` into the `restore2` directory

        tar xzf backup2.tar.gz -C restore2

Reip the `restore2@127.0.0.1`

        restore2/bin/riak-admin reip riak@127.0.0.1 restore2@127.0.0.1

* `reip` is necessary since we copied the ring directory from `riak@127.0.0.1`
* Using a managed hosts file is a better solution than using `reip`

Start the `restore2@127.0.0.1` node

        restore2/bin/riak start

Grep for the HTTP port for `restore2@127.0.0.1`

        grep http restore2/etc/app.config

Read the object using that HTTP port

        curl http://localhost:HTTP_PORT/riak/bar/dan
