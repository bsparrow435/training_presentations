# Getting Started - Clustering

1. Download the `generate-node.sh` script from Github, and make it executable:

        curl https://raw.github.com/gist/1672990 -o generate-node.sh
        chmod a+x generate-node.sh

2. Create three test nodes:

        ./generate-node.sh /path/to/bin/riak test1
        ./generate-node.sh /path/to/bin/riak test2
        ./generate-node.sh /path/to/bin/riak test3

3. Note that the `generate-node.sh` script uses the basename of the destination directory as the node name. For example, the above three nodes have the names `test1@127.0.0.1`, `test2@127.0.0.1`, and `test3@127.0.0.1`.

4. Start the three test nodes:

        test1/bin/riak start
        test2/bin/riak start
        test3/bin/riak start

5. Join the nodes into a cluster:

        test2/bin/riak-admin join test1@127.0.0.1
        test3/bin/riak-admin join test1@127.0.0.1

6. Review the status of the Riak node:

        riak-admin status

7. What is the value of `connected_nodes`?

8. What is the value of `ring_members`?

9. What is the value of `ring_ownership`?
