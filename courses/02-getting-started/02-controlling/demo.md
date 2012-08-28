# Getting Started - Controlling

## Start, Ping

Start Riak using `riak start`.

Ping Riak using `riak ping`.

## Attach

Attach to Riak using `riak attach`.

Demonstrate that you are connected to the Riak process by obtaining the OS PID
from the node using `os:getpid()`.

Disconnect from Riak by pressing CTRL-D. Make note that this is the only safe
way to disconnect from the node; the provided exercises will demonstrate unsafe methods.

Use `ps aux | grep beam` to find the OS PID and compare to the value returned by Riak.

## Console

Try to access the Riak console using `riak console`.

Note that you cannot access the console if Riak running.

Stop Riak using `riak stop`.

Try to access the Riak console using `riak console`.
