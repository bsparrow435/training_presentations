# Getting Started - Configuring

## vm.args

Open `etc/vm.args`.

Show the `-name` parameter.

Start Riak.

Run `ps aux | grep beam` and show the `-name` parameter in the process listing.

Explain that the `-name` parameter is specific to Erlang and required to be
unique for every running Erlang process on a particular machine.

Run `riak-admin test`.

Stop Riak.

Open `etc/vm.args`.

Change the `-name` parameter (e.g. RIAK@127.0.0.1).

Start Riak.

Run `riak-admin test`.

Explain that Riak maintains a ring file that notes the name of nodes that
belong to the cluster. In this case the ring file is still referencing the old
node name. Since there are no nodes running with the old node name, requests
cannot be processed.

Stop Riak.

Run `riak-admin reip riak@127.0.0.1 RIAK@127.0.0.1`.

Start Riak.

Run `riak-admin test`.
