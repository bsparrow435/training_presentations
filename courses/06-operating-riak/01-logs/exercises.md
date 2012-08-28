## Exercises

### Crash an Erlang Process

Remove the contents of Riak's log directory. (You should know where that is)

Launch a Riak console: `riak console`

In the console, enter the following:

    erlang:whereis(riak_core_node_watcher) ! crazy_talk.

What you are doing here is sending the node_watcher a message that it is not intended to handle.

This crashes an Erlang process, but not the Erlang virtual machine. What files do you expect to have entries?

Go look!

### Crash the Erlang VM ###

Make sure Riak is stopped.

Remove the contents of Riak's log directory, and then start Riak.

While it's easy to kill an Erlang process, it takes a bit more to make the Erlang virtual machine to crash. One way to do so is by sending a USR1 signal to the Riak process.

One way to send USR1 to your Riak process is:

    killall -SIGUSR1 beam.smp

What do you expect to see in the logs this time?

Compare your expectation to the contents of your actual log files.
