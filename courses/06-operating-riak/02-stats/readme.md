# Riak Status Reference #

## Access ##
cmd ```riak-admin status```

url ```http://node:port/stats```

## Cluster Information ##
**nodename**: The name of the node in question

**connected\_nodes**: The list of nodes connected to this node

**ring\_members**: The list of all nodes in the ring

**ring\_ownership**: The list of all nodes, with partition ownership

**storage\_backend**: The storage backend selected for this node.

**ring\_creation\_size**: The number of partitions this node is set for

**ring\_num\_partitions**: The number of partitions in the ring

## Version Information ##
**sys\_driver\_version**

**sys\_otp\_release**

**sys\_system\_version**

**ssl\_version**

**public\_key\_version**

**runtime\_tools\_version**

**basho\_stats\_version**

**riak\_search\_version**

**merge\_index\_version**

**luwak\_version**

**skerl\_version**

**riak\_kv\_version**

**bitcask\_version**

**luke\_version**

**mochiweb\_version**

**inets\_version**

**riak\_pipe\_version**

**riak\_core\_version**

**riak\_sysmon\_version**

**webmachine\_version**

**crypto\_version**

**os\_mon\_version**

**erlang\_js\_version**

**cluster\_info\_version**

**sasl\_version**

**lager\_version**

**basho\_metrics\_version**

**stdlib\_version**

**kernel\_version**


## CPU ##
CPU Stats are taken directly from erlang's cpu\_sup module. [ErlDocs: cpu_sup](http://erldocs.com/R14B04/os_mon/cpu_sup.html?i=0&search=cpu#undefined)

**cpu\_nprocs**: number of unix processes

**cpu\_avg1** \\ **cpu\_avg5** \\ **cpu\_avg15** : equivalent to top's "load average" when divided by 256. This is not a percentage, but rather the average number of active processes.

## Memory ##
Memory Stats are taken directly from the erlang vm. [ErlDocs: Memory](http://erldocs.com/R14B04/erts/erlang.html?i=0&search=erlang:memory#memory/0)

**memory_total**: Total memory available

**memory_processes**: 

**memory_processes_used**: 

**memory_system**: High values here could mean the node is running out of room for bitcask keys

**memory_atom**: 

**memory_atom_used**: 

**memory_binary**: 

**memory_code**: 

**memory_ets**: This will spike with riak\_search use

## Counters ##
**node\_puts**: Number of PUTs coordinated by this node, including PUTs to non-local nodes in the last minute

**node\_gets**: Number of GETs coordinated by this node, including GETs to non-local nodes in the last minute

**node\_puts\_total**: Number of PUTs coordinated by this node, including PUTs to non-local nodes since startup

**node\_gets\_total**: Number of GETs coordinated by this node, including GETs to non-local nodes since startup

**vnode\_puts**: Number of PUTs coordinated by vnodes local to this node in the last minute

**vnode\_gets**: Number of GETs coordinated by vnodes local to this node in the last minute

**vnode\_puts\_total**: Number of PUTs coordinated by vnodes local to this node since startup

**vnode\_gets\_total**: Number of GETs coordinated by vnodes local to this node since startup

**read\_repairs**: Read Repairs that this node has coordinated in the last minute

**read\_repairs\_total**: Read Repairs that this node has coordinated since startup

**coord\_redirs\_total**: Number of requests this node has redirected to other nodes for coordination since startup

## Timers ##
Measured in Microseconds

#### node\_get\_fsm\_time ####
**node\_get\_fsm\_time\_mean**: Mean time between when a GET request is received by this node and when a reply is sent to the client

**node\_get\_fsm\_time\_median**: Median time between when a GET request is received by this node and when a reply is sent to the client

**node\_get\_fsm\_time\_95**: 95th percentile time between when a GET request is received by this node and when a reply is sent to the client

**node\_get\_fsm\_time\_99**: 99th percentile time between when a GET request is received by this node and when a reply is sent to the client

**node\_get\_fsm\_time\_100**: 100th percentile time between when a GET request is received by this node and when a reply is sent to the client

#### node\_put\_fsm\_time ####
**node\_put\_fsm\_time\_mean**: Mean time between when a PUT request is received by this node and when a reply is sent to the client

**node\_put\_fsm\_time\_median**: Median time between when a PUT request is received by this node and when a reply is sent to the client

**node\_put\_fsm\_time\_95**: 95th percentile time between when a PUT request is received by this node and when a reply is sent to the client

**node\_put\_fsm\_time\_99**: 99th percentile time between when a PUT request is received by this node and when a reply is sent to the client

**node\_put\_fsm\_time\_100**: 100th percentile time between when a PUT request is received by this node and when a reply is sent to the client

#### node\_get\_fsm\_siblings ####
**node\_get\_fsm\_siblings\_mean**: Mean number of siblings encountered of all GETs by this node within the last minute

**node\_get\_fsm\_siblings\_median**: Median number of siblings encountered of all GETs by this node within the last minute

**node\_get\_fsm\_siblings\_95**: 95th percentile number of siblings encountered of all GETs by this node within the last minute

**node\_get\_fsm\_siblings\_99**: 99th percentile number of siblings encountered of all GETs by this node within the last minute

**node\_get\_fsm\_siblings\_100**: 100th percentile number of siblings encountered of all GETs by this node within the last minute

#### node\_get\_fsm\_objsize ####
**node\_get\_fsm\_objsize\_mean**: Mean size of an object on this node within the last minute

**node\_get\_fsm\_objsize\_median**: Median size of an object on this node within the last minute

**node\_get\_fsm\_objsize\_95**: 95th percentile size of an object on this node within the last minute

**node\_get\_fsm\_objsize\_99**: 99th percentile size of an object on this node within the last minute

**node\_get\_fsm\_objsize\_100**: 100th percentile size of an object on this node within the last minute
